#!/usr/bin/env python3
"""Keep independently selectable products independent of optional implementations."""
import json
from pathlib import Path
import subprocess
root=Path(__file__).resolve().parents[1]
package=json.loads(subprocess.check_output(['swift','package','--package-path',str(root),'dump-package'],text=True))
targets={t['name']:t for t in package['targets']}
permitted={
 'CapcapSupport': {'CapcapSupport'},
 'CapcapKit': {'CapcapKit','CapcapSupport'},
 'CapcapText': {'CapcapText','CapcapSupport'},
 'CapcapRecording': {'CapcapRecording','CapcapSupport'},
}
for name,expected in permitted.items():
 seen=set();pending=[name]
 while pending:
  item=pending.pop()
  if item in seen:continue
  seen.add(item)
  for dependency in targets[item]['dependencies']:
   for kind in ['byName','target']:
    if kind in dependency:pending.append(dependency[kind][0])
 assert seen==expected,(name,seen,expected)
 print(name+': '+', '.join(sorted(seen)))
