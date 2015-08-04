# Utility functions

def get_version_number(path)
    get_plist_key('CFBundleShortVersionString', path)
end

def get_build_number(path)
    get_plist_key('CFBundleVersion', path)
end

def get_plist_key(key, path)
    raise "plist #{path} does not exist!" unless File.exist? path
      %x(/usr/libexec/plistbuddy -c Print:#{key} "#{path}").strip
end

def generate_build_number
    Time.new.strftime("%Y%m%d%H%M%S")
end
