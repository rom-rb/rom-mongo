require 'rom'

require 'rom/mongo/version'
require 'rom/mongo/repository'

ROM.register_adapter(:mongo, ROM::Mongo)
