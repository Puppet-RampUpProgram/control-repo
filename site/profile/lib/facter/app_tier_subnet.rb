# Accessible in puppet as $::app_tier_subnet
require 'ipaddr'
Facter.add(:app_tier_subnet) do
  setcode do
    begin
      # Set segment_name to nil
      # If error occures the nil will be passed
      segment_name = nil
      # Mapping of vlans to ipaddresses
      # NOTE: To extend this fact, modify this hash
      vlan_segments = {
        'prod'  => IPAddr.new('10.10.10/22'),
        'dev'   => IPAddr.new('11.11.11/22'),
        'uat'   => IPAddr.new('12.12.12/22'),
        'cloud' => IPAddr.new('13.13.13/24'),
      }

      # Iterate through all segments and find the one that matches
      vlan_segments.each do |segment, address|
        if address.include?(Facter.value(:ipaddress))
          segment_name = segment
          break
        end
      end

      # Return the name of the segment that matches
      segment_name
    rescue
      segment_name
    end
  end
end
