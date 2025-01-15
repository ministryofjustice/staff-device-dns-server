import dns.resolver
from multiprocessing import Pool

def blast_pdns(dns_records_to_lookup: dict):
    # for dns_record in dns_records_to_lookup:
    try:
        resolver = dns.resolver.Resolver()
        resolver.nameservers = ['25.25.25.25']  # PDNS
        answer = resolver.resolve(dns_records_to_lookup['domain'], dns_records_to_lookup['record_type'])
        status = {"status": "healthy", "result": str(answer.rrset)}
        print(f"Health Check success: {status}")
    except Exception as e:
        error_status = {"status": "unhealthy", "error": str(e)}
        print(f"Health Check Failed: {error_status}")

if __name__ == "__main__":
  dns_records_to_lookup = []
  with open('cf-queryfile.txt', 'r') as file:
    for line in file:
      domain, record_type = line.strip().split()
      dns_records_to_lookup.append({"domain": domain, "record_type": record_type})

  with Pool(processes=16) as p:
    p.map(blast_pdns, dns_records_to_lookup)

  # with open("cf-queryfile.txt", "a") as f:
  #   for key in answer_list:
  #     f.write(str(key['domain'])[:-1] + f' {str(key['record_type'])}' + "\n")
