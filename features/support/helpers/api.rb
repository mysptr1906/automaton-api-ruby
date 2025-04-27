class Api

    class << self

        def request(method, url, headers = {}, body = nil, timeout = nil)
            method = method.to_sym

            options = {
                headers: headers,
                body: body,
                timeout: timeout
            }.compact

            start_time = Process.clock_gettime(Process::CLOCK_MONOTONIC)

            response = HTTParty.send(method, url, **options)
        end
    end
end
