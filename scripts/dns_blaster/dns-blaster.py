import dns.resolver
from multiprocessing import Pool

def blast_pdns(dns_record: dict):
    try:
        resolver = dns.resolver.Resolver()
        resolver.nameservers = ['25.25.25.25']  # PDNS
        answer = resolver.resolve(dns_record['domain'], dns_record['record_type'])
        status = {"status": "healthy", "result": str(answer.rrset)}
        return status
    except Exception as e:
        error_status = {"status": "unhealthy", "error": str(e)}
        return error_status

if __name__ == "__main__":
  iterations = 10
  while iterations > 0:
    dns_records_to_lookup = []
    with open('cf-queryfile.txt', 'r') as file:
      for line in file:
        domain, record_type = line.strip().split()
        dns_records_to_lookup.append({"domain": domain, "record_type": record_type})

    with Pool(processes=16) as p:
      dns_replys = p.map(blast_pdns, dns_records_to_lookup)
      dns_unhealthy_replies = []
      for dns_unhealthy_reply in dns_replys:
        if dns_unhealthy_reply['status'] == "healthy":
          pass
        elif dns_unhealthy_reply['status'] == "unhealthy":
          dns_unhealthy_replies.append(dns_unhealthy_reply)
        else:
          raise Exception("dns_unhealthy_reply status must be healthy or unhealthy: {status} is not valid".format(status=dns_unhealthy_reply['status']))

      print(dns_unhealthy_replies)

    with open("query_error.log", "a") as f:
      for dns_unhealthy_reply in dns_unhealthy_replies:
        f.write(str(dns_unhealthy_replies) + "\n")

    iterations = iterations - 1
