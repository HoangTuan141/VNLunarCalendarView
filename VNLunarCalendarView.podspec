Pod::Spec.new do |s|
  s.name             = 'VNLunarCalendarView'
  s.version          = '0.1.2'
  s.summary          = 'Vietnam Lunar Calendar View'
 
  s.description      = <<-DESC
This excellent view has provided a user-friendly lunar calendar view and its functions
                       DESC
 
  s.homepage         = 'https://github.com/HoangTuan141/VNLunarCalendarView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Hoang Anh Tuan' => 'ios.tuanha@gmail.com' }
  s.source           = { :git => 'https://github.com/HoangTuan141/VNLunarCalendarView', :tag => s.version.to_s }
 
  s.ios.deployment_target = '10.0'
  s.source_files = 'VNLunarCalendarView/***/**/*.swift'
  s.resource_bundle = {
    'LunarDayCell' => 'VNLunarCalendarView/**/*.xib',
    'LunarMonthView' => 'VNLunarCalendarView/**/*.xib',
    'VNLunarCalendarView' => 'VNLunarCalendarView/**/*.xib'
}
  s.resource = 'VNLunarCalendarView/**/*.xib'
end