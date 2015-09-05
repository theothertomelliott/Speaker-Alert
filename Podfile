xcodeproj 'SpeakerAlert/SpeakerAlert.xcodeproj/'

# Uncomment this line to define a global platform for your project
platform :ios, '8.0'
use_frameworks!

target 'SpeakerAlert' do
	pod "MagicalRecord"
	pod "Typhoon"
	pod "FontAwesome.swift", :git => 'https://github.com/theothertomelliott/FontAwesome.swift.git'
	pod "TWETimeIntervalField", :git => 'https://github.com/theothertomelliott/TWETimeIntervalField.git'
	pod "RFAboutView", '~> 1.0.4'
	pod 'Colours', '~> 5'
end

target 'SpeakerAlertTests' do
	pod "MagicalRecord"
	pod "Typhoon"
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
