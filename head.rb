#!/usr/bin/env ruby
data = STDIN.read
head = `git rev-parse HEAD`.chomp
puts data.gsub('$Head$', '$Head: ' + head.to_s + '$')
