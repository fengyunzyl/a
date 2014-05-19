if ($args.length -ne 3) {
  '{0} SEARCH SORT CATEGORY' -f $MyInvocation.MyCommand.Name
  ''
  'SORT'
  '3  date ↓'
  '6  size ↑'
  '7  seeders ↓'
  ''
  'CATEGORY'
  '100  Audio'
  '104  Audio FLAC'
  '201  Video Movies'
  '205  Video TV shows'
  '207  Video HD Movies'
  '208  Video HD TV shows'
  '301  Applications Windows'
  exit
}

Start-Process ('http://thepiratebay.se/search/{0}/0/{1}/{2}' -f $args)
