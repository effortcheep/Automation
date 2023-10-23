require 'spaceship'
require 'dotenv/load'

def update_and_download_profile(profile_name, all_devices)
  # 查找指定名称的 Ad Hoc 描述文件
  profile = Spaceship.provisioning_profile.ad_hoc.all.find { |p| p.name == profile_name }
  if profile
    # 更新描述文件的设备列表
    profile.devices = all_devices
    # 重新生成描述文件
    profile = profile.update!
    # 下载描述文件
    File.write("#{profile_name}.mobileprovision", profile.download)
  else
    puts "未找到名为 '#{profile_name}' 的 Ad Hoc 描述文件"
  end

end

def login(username, password)
  Spaceship.login(username, password)
end

def add_new_device(device_name, device_udid)
  device_udid = device_udid
  device_name = device_udid
  Spaceship.device.create!(name: device_name, udid: device_udid)
  all_devices = Spaceship.device.all
end

def resign_app(ipa_path, signing_identity, provisioning_profile)
  system("fastlane run resign ipa:'#{ipa_path}' signing_identity:'#{signing_identity}' provisioning_profile:#{provisioning_profile}")
end

username = ENV['APP_USERNAME']
password = ENV['APP_PASSWORD']

login(username, password)

# 更新描述文件
update_and_download_profile(ENV['APP_PROFILE_NAME'], Spaceship.device.all)
update_and_download_profile(ENV['APP_EXTENSION_PROFILE_NAME'], Spaceship.device.all)

# ipa_path = ENV['IPA_PATH']
# signing_identity = ENV['SIGNING_IDENTITY']
# provisioning_profile = ENV['PROVISIONING_PROFILE']
# resign_app(ipa_path, signing_identity, provisioning_profile)



