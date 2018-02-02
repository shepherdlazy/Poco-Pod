Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "Poco-minimal"
  s.version      = "1.8.1"
  s.summary      = "Powerful open source C++ class libraries."
  s.description  = <<-DESC
  Powerful open source C++ class libraries (https://pocoproject.org). 迷你版,只打入基本库(Foundation、Net、XML、JSON、Util)
  DESC
  s.homepage     = "https://github.com/shepherdlazy/Poco-Pod"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "Boost Software License"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author      = { "Raven Du" => "Raven.Du@hotmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "7.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :http => "https://github.com/shepherdlazy/Poco-Pod/releases/download/v1.8.1/poco-1.8.1-minimal-sdk11.2.tar.gz", :sha256 => "62dd8442d88d02dfa687807a196406c7746fb3340a4b29b5dc2f314f1bd75a8c" }

  # ――― Source Code ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.header_dir = "Poco"

  s.subspec 'Foundation' do |ss|
    ss.header_dir = "Poco"
    ss.source_files = 'POCOIncludes/Poco/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/*.h'
  end

  s.subspec 'DOM' do |ss|
    ss.header_dir = "Poco/DOM"
    ss.source_files = 'POCOIncludes/Poco/DOM/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/DOM/*.h'
  end

  s.subspec 'Dynamic' do |ss|
    ss.header_dir = "Poco/Dynamic"
    ss.source_files = 'POCOIncludes/Poco/Dynamic/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/Dynamic/*.h'
  end

  s.subspec 'SAX' do |ss|
    ss.header_dir = "Poco/SAX"
    ss.source_files = 'POCOIncludes/Poco/SAX/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/SAX/*.h'
  end

  s.subspec 'Redis' do |ss|
    ss.header_dir = "Poco/Redis"
    ss.source_files = 'POCOIncludes/Poco/Redis/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/Redis/*.h'
  end

  s.subspec 'Net' do |ss|
    ss.header_dir = "Poco/Net"
    ss.source_files = 'POCOIncludes/Poco/Net/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/Net/*.h'
  end

  s.subspec 'XML' do |ss|
    ss.header_dir = "Poco/XML"
    ss.source_files = 'POCOIncludes/Poco/XML/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/XML/*.h'
  end

  s.subspec 'JSON' do |ss|
    ss.header_dir = "Poco/JSON"
    ss.source_files = 'POCOIncludes/Poco/JSON/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/JSON/*.h'
  end

  s.subspec 'Util' do |ss|
    ss.header_dir = "Poco/Util"
    ss.source_files = 'POCOIncludes/Poco/Util/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/Util/*.h'
  end

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.vendored_libraries  = "lib/*.a"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = false

end
