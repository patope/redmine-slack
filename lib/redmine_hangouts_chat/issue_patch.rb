module RedmineHangoutsChat
	module IssuePatch
		def self.included(base) # :nodoc:
			base.extend(ClassMethods)
			base.send(:include, InstanceMethods)

			base.class_eval do
				unloadable # Send unloadable so it will not be unloaded in development
				after_create :create_from_issue
				after_save :save_from_issue
			end
		end

		module ClassMethods
		end

		module InstanceMethods
			def create_from_issue
				@create_already_fired = true
				Redmine::Hook.call_hook(:redmine_hangouts_chat_issues_new_after_save, { :issue => self})
				return true
			end

			def save_from_issue
				if not @create_already_fired
					Redmine::Hook.call_hook(:redmine_hangouts_chat_issues_edit_after_save, { :issue => self, :journal => self.current_journal}) unless self.current_journal.nil?
				end
				return true
			end

		end
	end
end
