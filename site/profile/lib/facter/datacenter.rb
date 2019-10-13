Facter.add(:datacenter) do
  setcode do
    datacenters_map = {
      'lax'    => ['lax', 'lax2', 'hq'],
      'dc'     => ['dc', 'dc2', 'dc3', 'foo'],
      'london' => ['lon', 'uk', 'london', 'bar'],
      'none'   => ['localhost', 'local'],
    }

    # Assume that all hostnames look like this:
    #   lax-prod-www-291
    #   dc-dev-www-111
    #   lon-prod-db-101
    # The 'datacenter' segment is the first part of a host name.
    first_segment = Facter.value(:hostname).split('-')[0]

    datacenter = nil

    datacenters_map.each do |datacenter_name, datacenter_aliases|
      if datacenter_aliases.include? first_segment
        datacenter = datacenter_name
        break
      end
    end
    datacenter
  end
end
