listView("Boot Seed Sync") {
    columns {
        status()
        weather()
        name()
        lastSuccess()
        lastFailure()
        lastDuration()
        buildButton()
    }
    filterBuildQueue()
    filterExecutors()
    jobs {
        regex(/(?i)((seed|_run_at_boot_|casc_config_sync))/)
    }
}