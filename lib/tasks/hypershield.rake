namespace :hypershield do
  task refresh: :environment do
    abort "Hypershield is not enabled in this environment. Do a dry run with: rake hypershield:refresh:dry_run" unless Hypershield.enabled

    $stderr.puts "[hypershield] Refreshing schemas"
    Hypershield.refresh
    $stderr.puts "[hypershield] Success!"
  end

  namespace :refresh do
    task dry_run: :environment do
      Hypershield.refresh(dry_run: true)
    end
  end
end

Rake::Task["db:migrate"].enhance do
  Rake::Task["hypershield:refresh"].invoke if Hypershield.enabled
end

Rake::Task["db:rollback"].enhance do
  Rake::Task["hypershield:refresh"].invoke if Hypershield.enabled
end
