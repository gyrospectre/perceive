#
# ansible-host-to-zone.py
#

import ConfigParser,argparse,os.path

def ParseHosts(hostfile,zonefile,simulate=False):
  config = ConfigParser.ConfigParser()
  config.read(hostfile)

  for section in config.sections():
    for key in config.items(section):
      name=section.split("-")[0]
      addr=key[0].split(" ")[0]
      formatted="{}                     IN      A       {}".format(name,addr)

      if simulate:
        # Just output to stdout
        print formatted
      else:
        # Append to the zonefile
        with open(zonefile, "a") as zone_file:
          zone_file.write("{}\n".format(formatted))

def main():
  # Main
  parser = argparse.ArgumentParser(description="Parse an Ansible host file into BIND format and add to a zone file.")
  required = parser.add_argument_group('required arguments')
  required.add_argument("--hosts", help="the Ansible host file to parse", required=True)
  required.add_argument("--zone", help="the BIND zone file to output to", required=True)
  parser.add_argument("--simulate", help="don't write to output file, just stdout", action='store_true')
  args=parser.parse_args()

  # Check files exist and then go!
  if not os.path.isfile(args.hosts):
    print "Error: Host file {} does not exist!".format(args.hosts)
    exit(2)

  if not os.path.isfile(args.zone):
    print "Error: Zone file {} does not exist!".format(args.zone)
    exit(2)

  ParseHosts(args.hosts,args.zone,args.simulate)

if __name__== "__main__":
  main()
