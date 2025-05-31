# frozen_string_literal: true

cores = Concurrent.physical_processor_count

threads cores, cores
port 3000
