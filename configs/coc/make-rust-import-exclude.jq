#!/usr/bin/env -S /bin/jq -nsRcf

"(?<tt>
  (?<tree>
    \\{
      \\s* \\g<tt> \\s*
      (?:
        ,
        \\s* (?:\\g<tt> \\s*)?
      )*
    \\}
    |
    \\{ \\s* \\}
  )
  |
  [^\\s{,}]+ (?:\\s*\\g<tree>)?
)" as $group |

def make: {path: ., type: "always"};
def tree($parent):
  scan($group; "xm") as [$prefix, $rest] |
  $prefix | rtrimstr($rest) as $prefix |
  if $rest then
    $rest | sub("^\\{"; "") | sub("\\}$"; "") | tree($parent+$prefix)
  else
    $parent+$prefix | make
  end
  ;

[ inputs |
  splits(";") |
  sub("^\\s*pub\\s*"; ""; "m") |
  sub("^\\s*use\\s*"; ""; "m") |
  sub("\\s*;\\s*$"; ""; "m") |
  select(length > 0) |
  tree("") ]
