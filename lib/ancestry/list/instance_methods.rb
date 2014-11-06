module Ancestry
  module List
    module InstanceMethods
      def move_to_child_of(reference_instance)
        transaction do
          remove_from_list
          self.update_attributes!(:parent => reference_instance)
          add_to_list_bottom
          save!
        end
      end

      def move_to_left_of(reference_instance)
        transaction do
          remove_from_list
          reference_instance.reload # Things have possibly changed in this list
          self.update_attributes!(:parent_id => reference_instance.parent_id)
          reference_item_position = reference_instance.position
          increment_positions_on_lower_items(reference_item_position)
          self.update_attribute(:position, reference_item_position)
        end
      end

      def move_to_right_of(reference_instance)
        transaction do
          remove_from_list
          reference_instance.reload # Things have possibly changed in this list
          self.update_attributes!(:parent_id => reference_instance.parent_id)
          if reference_instance.lower_item
            lower_item_position = reference_instance.lower_item.position
            increment_positions_on_lower_items(lower_item_position)
            self.update_attribute(:position, lower_item_position)
          else
            add_to_list_bottom
            save!
          end
        end   
      end
    end
  end
end
