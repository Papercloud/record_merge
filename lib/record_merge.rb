require "record_merge/engine"

module RecordMerge

  def self.merge(destination, source, options={})
    attributes     = options[:attributes] || []
    only           = options[:only] || []
    except         = options[:except] || []
    copy_relations = options[:copy_relations] || true
    attributes     = sanitize_attributes(attributes)

    raise "classes don't match" if destination.class.base_class != source.class.base_class
    raise "can't send only and except params" if only.any? && except.any?

    ActiveRecord::Base.transaction do
      attributes.each do |attribute|
        eval("destination.#{attribute} = source.#{attribute}")
      end

      if copy_relations
        relations = source.class.reflections

        relations.each do |relation|
          relation_name = relation[0]
          next if except.include?(relation_name.to_sym) && except.any?
          next if !only.include?(relation_name.to_sym) && only.any?

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

      source.destroy! && destination.save!
    end

    destination
  end

  private

  def self.sanitize_attributes(attributes)
    if attributes.include?(:id)
      attributes.delete(:id)
    end
    attributes
  end
end
