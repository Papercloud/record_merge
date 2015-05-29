require "record_merge/engine"

module RecordMerge

  def self.merge(destination, source, options={})
    attributes         = options[:attributes] || [] # Attributes on model
    only               = options[:only] || [] # Only these relationships
    except             = options[:except] || [] # Except these relationships
    copy_all_relations = options[:copy_all_relations] || true
    delete_source      = options[:delete_source] || true # Delete the source on complete

    # Sanitize the values
    attributes     = sanitize_attributes(attributes)

    raise AssertionError.new("source and destination classes don't match") if destination.class.base_class != source.class.base_class
    raise AssertionError.new("can't provide both only and except params") if only.any? && except.any?

    ActiveRecord::Base.transaction do
      attributes.each do |attribute|
        eval("destination.#{attribute} = source.#{attribute}")
      end

      if copy_all_relations || only.any? || except.any?
        relations = source.class.reflections

        relations.each do |relation|
          relation_name = relation[0]
          next if except.include?(relation_name.to_sym) && except.any?
          next if only.include?(relation_name.to_sym) && only.any?

          if source.send(relation_name)
            case relation[1].class.name
            when "ActiveRecord::Reflection::HasOneReflection"
              source.send(relation_name).update("#{relation[1].foreign_key}": destination.id)
            when "ActiveRecord::Reflection::HasManyReflection"
              source.send(relation_name).update_all("#{relation[1].foreign_key}": destination.id)
            when "ActiveRecord::Reflection::BelongsToReflection"
              destination.update("#{relation_name}": source.send(relation_name))
            when "ActiveRecord::Reflection::HasAndBelongsToManyReflection"
              destination.update("#{relation_name}": source.send(relation_name))
            end
          end
        end

      end
      source.destroy! if delete_source

      destination.save!
    end

    destination
  end

  private

  def self.sanitize_attributes(attributes)
    if attributes.include?(:id)
      puts "Cannot modify the ID of the destination."
      attributes.delete(:id)
    end
    attributes
  end

  class AssertionError < StandardError ; end
end


