#  _____ _____ _____ _____     _   
# |  _  | __  |   __| __  |___| |_ 
# |     |    -|  |  | __ -| . |  _|
# |__|__|__|__|_____|_____|___|_|  

require 'base64'
require 'digest/md5'
require 'digest/sha1'
require 'digest/sha2'

module ARGBot
  module CryptoCommands
    def cr_md5(m, args)
      m.reply "MD5(\"#{args}\"): #{Digest::MD5.hexdigest(args)} - not recommended for cryptographical purposes"
    end
    
    def cr_sha256(m, args)
      m.reply "SHA256(\"#{args}\"): #{(Digest::SHA2.new(256) << args).to_s}"
    end
    
    def cr_sha512(m, args)
      m.reply "SHA512(\"#{args}\"): #{(Digest::SHA2.new(512) << args).to_s}"
    end

    def cr_base64e(m, args)
      m.reply "BASE64E(\"#{args}\"): #{Base64.encode64(args)}"
    end

    def cr_base64d(m, args)
      m.reply "BASE64D(\"#{args}\"): #{Base64.decode64(args)}"
    end

    def cr_rot13(m, args)
      m.reply "ROT13(\"#{args}\"): #{args.tr 'A-Za-z', 'N-ZA-Mn-za-m'}"
    end
  end
  
  cmd :crypto, :cr_md5, [:md5sum, :md5, :m], 'Takes the MD5 hash of some text', '%s <text>'
  cmd :crypto, :cr_sha256, [:sha256, :s256], 'Takes a 256-bit SHA2 hash of some text', '%s <text>'
  cmd :crypto, :cr_sha512, [:sha512, :s512], 'Takes a 512-bit SHA2 hash of some text', '%s <text>'
  cmd :crypto, :cr_base64e, [:base64e, :base64, :b64], 'Encodes a string with base64', '%s <text>'
  cmd :crypto, :cr_base64d, [:base64d, :b64d], 'Decodes a base64-encoded string', '%s <base64>'
  cmd :crypto, :cr_rot13, [:rot13, :r13], 'Encodes a string with rot13', '%s <text>'
end
