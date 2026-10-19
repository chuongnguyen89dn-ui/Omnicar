#!/usr/bin/env python3
"""Repeatable STATIC skin API and Settings symbol audit for extracted OmniCar."""
from pathlib import Path
import argparse,csv,hashlib,json,plistlib,subprocess
p=argparse.ArgumentParser()
p.add_argument('--root',type=Path,required=True)
p.add_argument('--out',type=Path,required=True)
a=p.parse_args()
a.out.mkdir(parents=True,exist_ok=True)
groups={
'component_types':['UIView','UIButton','UILabel','UIImageView','UIVisualEffectView','CAGradientLayer','CAShapeLayer','UIBezierPath'],
'color_alpha':['colorWithRed:green:blue:alpha:','setBackgroundColor:','setTintColor:','setTextColor:','setFillColor:','setStrokeColor:','setColors:','setAlpha:','setOpacity:'],
'border_shape':['setCornerRadius:','setCornerCurve:','setMaskedCorners:','setBorderColor:','setBorderWidth:','setLineWidth:','setPath:'],
'glass_shadow':['effectWithStyle:','setShadowColor:','setShadowOpacity:','setShadowRadius:','setShadowOffset:'],
'typography_icons':['setFont:','systemImageNamed:','imageWithTintColor:renderingMode:','setImage:forState:']}
root=a.root
binaries=sorted(list(root.rglob('*.dylib'))+[root/'var/jb/Applications/OmniCar.app/OmniCar',root/'var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle/OmniCarPrefs'])
rows=[]
for f in binaries:
 if not f.is_file():continue
 raw=f.read_bytes()
 strings=set(subprocess.check_output(['strings','-a',str(f)],text=True,errors='replace').splitlines())
 for category,terms in groups.items():
  for term in terms:
   rows.append(dict(path=f.relative_to(root).as_posix(),category=category,symbol=term,present_in_binary_strings='yes' if any(term in s for s in strings) else 'no',runtime_element_binding='unverified',binary_sha256=hashlib.sha256(raw).hexdigest()))
with (a.out/'skin_api_presence.csv').open('w',encoding='utf-8',newline='') as o:
 writer=csv.DictWriter(o,fieldnames=list(rows[0]));writer.writeheader();writer.writerows(rows)
settings=[]
for f in sorted((root/'var/jb/Library/PreferenceBundles/OmniCarPrefs.bundle').glob('*.plist')):
 try:obj=plistlib.loads(f.read_bytes())
 except Exception:continue
 def walk(x):
  if isinstance(x,dict):
   if any(k in x for k in ('cell','symbol','featureSymbol','key')):
    settings.append(dict(file=f.name,key=str(x.get('key','')),label=str(x.get('label','')),symbol=str(x.get('symbol',x.get('featureSymbol',''))),cell=str(x.get('cell',''))))
   for v in x.values():walk(v)
  elif isinstance(x,list):
   for v in x:walk(v)
 walk(obj)
with (a.out/'settings_skin_symbols.csv').open('w',encoding='utf-8',newline='') as o:
 writer=csv.DictWriter(o,fieldnames=['file','key','label','symbol','cell']);writer.writeheader();writer.writerows(settings)
stats=dict(binaries=len(binaries),checks=len(rows),api_hits=sum(r['present_in_binary_strings']=='yes' for r in rows),settings_items=len(settings),png=len(list(root.rglob('*.png'))),caveat='binary API presence is not proof of per-view runtime use')
(a.out/'skin_scan_summary.json').write_text(json.dumps(stats,ensure_ascii=False,indent=2)+'\n',encoding='utf-8')
print(json.dumps(stats,ensure_ascii=False))
