# frozen_string_literal: true

module ConjurAudit
  class Engine < ::Rails::Engine
    isolate_namespace ConjurAudit

    initializer :append_migrations do |app|
      unless app.root.to_s.match root.to_s
        config.paths["db/migrate"].expanded.each do |expanded_path|
          app.config.paths["db/migrate"] << expanded_path
        end
      end
      if defined?(config.audit_database)
        db = Sequel.connect db
        db.extension :pg_json
        Message.db.extension :pg_json
        Message.set_dataset db[:messages]
      end
    end

    config.generators do |gen|
      gen.test_framework :rspec
      gen.assets false
      gen.helper false
      gen.template_engine false
      gen.orm :sequel
    end
    
    initializer :load_sequel_extensions do
      Sequel.extension :pg_json_ops
    end
  end
end
