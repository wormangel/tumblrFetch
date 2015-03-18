#!/usr/bin/env ruby
require 'tumblr_client'
require 'curb'
require 'sinatra'
require 'zip'
require 'rubygems'

$dir = Dir.pwd + '/tmp/'

get '/tumblrFetch' do
	cleanup
	fetch_pic(params[:url])
end

def cleanup
	Dir.foreach($dir) {|f| fn = File.join($dir, f); File.delete(fn) if !File.directory?(fn)} if Dir.exists?($dir)
end

def fetch_pic(base_url)

	# something.tumblr.com
	tumblr_url = base_url.split("/")[2]

	# something
	username = tumblr_url
	username[".tumblr.com"] = ''

	# 12345
	post_id = base_url.split("/")[4]

	# Authenticate via OAuth
	client = Tumblr::Client.new :consumer_key => ENV["TUMBLR_CONSUMER_KEY"]

	# Make the request
	response = client.posts tumblr_url, :id => post_id, :reblog_info => true

	# The post fetched
	post = response["posts"][0]
	
	if post["type"] != 'photo'
		return "Post must be of Photo type"
	end

	# Liked timestamp
	liked_timestamp = post["liked_timestamp"]
	date = post["date"]
	
	# The post short URL
	short_url = post["short_url"]
	short_url_handle = short_url.delete("http://tmblr.co/")

	# The photos
	photos = post["photos"]

	# The first picture URL TODO grab every picture
	n_pics = post["photos"].size

  files = []
	photos.each.with_index do |pic, i|
		url = pic["original_size"]["url"]
		puts 'Pic ' + i.to_s + ': ' + url
	
		# Mount the filename
		Dir.mkdir($dir) unless File.exists?($dir)
		filename = liked_timestamp.to_s + '_' + username + '_id' + post_id.to_s + '_' + short_url_handle + '_' + (i+1).to_s + url[-4..-1]
		filename = filename.slice(1,filename.length) if filename.start_with?("_") # if we don't have liked_timestamp

		# Download the image
		curl = Curl::Easy.new(url)
		curl.perform
		f = File.open($dir + filename, 'w') {|f| f.write(curl.body_str)}
		files << { "path" => $dir + filename, "filename" => filename }
	end
	
	if n_pics == 1
	  send_file files[0]["path"], :filename => files[0]["filename"], :type => 'Application/octet-stream'
	else
		zip_name = username + '_id' + post_id.to_s + '_t' + timestamp.to_s + "__" + n_pics.to_s + ".zip"
		zip_path = $dir + zip_name
		
		Zip::File.open(zip_path, Zip::File::CREATE) do |zipfile|
			files.each do |f|
				zipfile.add(f["filename"], f["path"])
			end
		end
		
		send_file zip_path, :filename => zip_name, :type => 'Application/octet-stream'
	end
end