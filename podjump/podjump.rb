namespaces = {
  preprod: 'offender-management-preprod',
  prod: 'offender-management-production',
  stage: 'offender-management-staging',
  test: 'offender-management-test',
  test2: 'offender-management-test2'
}

namespace = ARGV[0]

unless namespace && namespaces.keys.include?(namespace.to_sym)
  puts "Namespace must be one of:\n #{namespaces.keys.join("\n ")}"
  exit 1
end

pods = `kubectl --context live.cloud-platform.service.justice.gov.uk -n #{namespaces[namespace.to_sym]} get pods`

app_pods = pods.split("\n").grep(/allocation-manager/).map { |line| line.split(' ').first }
app_pod = app_pods.sample

system("kubectl --context live.cloud-platform.service.justice.gov.uk -n #{namespaces[namespace.to_sym]} exec -it #{app_pod} -- /bin/bash")