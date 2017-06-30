require 'rom/core'

require 'rom/mongo/version'
require 'rom/mongo/relation'
require 'rom/mongo/gateway'

ROM.register_adapter(:mongo, ROM::Mongo)
