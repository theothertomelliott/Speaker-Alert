xcodeproj 'SpeakerAlert/SpeakerAlert.xcodeproj/'

# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'SpeakerAlert' do
	pod "MagicalRecord", '2.3.0'
	pod "Typhoon", '3.4.5'
	pod "FontAwesome.swift", :git => 'https://github.com/theothertomelliott/FontAwesome.swift.git'
	pod "RFAboutView", '1.0.4'
	pod 'Colours', '5.13.0'
	pod 'IQKeyboardManager', '4.0.0'
end

target 'SpeakerAlertTests' do
	pod "MagicalRecord", '2.3.0'
	pod "Typhoon", '3.4.5'
end

target 'SpeakerAlertUITests' do

end

target 'SpeakerAlert WatchKit App' do

end

target 'SpeakerAlert WatchKit Extension' do

end

post_install do |installer|
  require 'fileutils'
  FileUtils.cp_r('Pods/Target Support Files/Pods-SpeakerAlert/Pods-SpeakerAlert-acknowledgements.plist', 'SpeakerAlert/Acknowledgements.plist', :remove_destination => true)
end
