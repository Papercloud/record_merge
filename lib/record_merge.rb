require "record_merge/engine"

module RecordMerge
  def self.merge(destination, source, attributes=[], options={})
    attributes.each do |attribute|
      eval("destination.#{attribute} = source.#{attribute}")
    end
    return destination
  end
end
