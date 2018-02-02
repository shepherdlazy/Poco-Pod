Pod::Spec.new do |s|

  # ―――  Spec Metadata  ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.name         = "Poco-standard"
  s.version      = "1.8.1"
  s.summary      = "Powerful open source C++ class libraries."
  s.description  = <<-DESC
  Powerful open source C++ class libraries (https://pocoproject.org).
  DESC
  s.homepage     = "https://github.com/shepherdlazy/Poco-Pod"

  # ―――  Spec License  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.license      = "Boost Software License"

  # ――― Author Metadata  ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.author      = { "Raven Du" => "Raven.Du@hotmail.com" }

  # ――― Platform Specifics ――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.platform     = :ios, "7.0"

  # ――― Source Location ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.source       = { :http => "https://github.com/shepherdlazy/Poco-Pod/releases/download/v1.8.1/poco-1.8.1-standard-sdk11.2.tar.gz", :sha256 => "37beec2639476f66b0dd109a2a1a3418dcd1d65802ee78656fbf428a92d77765" }

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

  s.subspec 'Crypto' do |ss|
    ss.header_dir = "Poco/Crypto"
    ss.source_files = 'POCOIncludes/Poco/Crypto/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/Crypto/*.h'
  end

  s.subspec 'Data' do |ss|
    ss.header_dir = "Poco/Data"
    ss.source_files = 'POCOIncludes/Poco/Data/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/Data/*.h'

    ss.subspec 'SQLite' do |sss|
      sss.header_dir = "Poco/Data/SQLite"
      sss.source_files = 'POCOIncludes/Poco/Data/SQLite/*.h'
      sss.public_header_files = 'POCOIncludes/Poco/Data/SQLite/*.h'
    end
  end

  s.subspec 'Zip' do |ss|
    ss.header_dir = "Poco/Zip"
    ss.source_files = 'POCOIncludes/Poco/Zip/*.h'
    ss.public_header_files = 'POCOIncludes/Poco/Zip/*.h'
  end

  # ――― Project Linking ―――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.vendored_libraries  = "lib/*.a"

  # ――― Project Settings ――――――――――――――――――――――――――――――――――――――――――――――――――――――――― #
  s.requires_arc = false
  s.dependency  'OpenSSL', '~> 1.0.210'

end
