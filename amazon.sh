# The top 10 IPs making the most requests, displaying the IP address and number
# of requests made
awk '{print $1}' who_interview_sample_access_log.bin | sort | uniq -c |
  sort -r | head

# Who is the owner of each of these IPs
awk '{print $1}' who_interview_sample_access_log.bin | sort | uniq -c |
sort -r | head |
while read count ip
do
  whois $ip
done

# Top 10 requested pages and the number of requests made for each
awk '{print $7}' who_interview_sample_access_log.bin | sort | uniq -c |
  sort -r | head

# percentage of successful requests
awk '
{total++}
$(NF-1) == 200 {good++}
END {print good/total}
' who_interview_sample_access_log.bin

# percentage of unsuccessful requests
awk '
{total++}
$(NF-1) == 404 {bad++}
END {print bad/total}
' who_interview_sample_access_log.bin

# top 10 unsuccessful page requests
awk '$(NF-1) == 404 {print $(NF-3)}' who_interview_sample_access_log.bin |
  sort | uniq -c | sort -r | head

# the total number of requests made every minute in the time period covered
awk '
BEGIN {
  minute = 60
}
{
  if ($3 != minute) {
    print count
    count = 0
    minute = $3
  }
  count++
}
' FS=: who_interview_sample_access_log.bin

# for each of the top 10 ips, show the top 5 pages requested and the number of
# requests for each
awk '{print $1}' who_interview_sample_access_log.bin | sort | uniq -c |
sort -r | head |
while read count ip
do
  awk '$1 == foo {print $(NF-3)}' foo=$ip who_interview_sample_access_log.bin |
    sort | uniq -c | sort -r | head -5
  echo
done
