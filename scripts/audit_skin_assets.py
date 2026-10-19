#!/usr/bin/env python3
"""Audit images from extracted OmniCar package. Pillow is optional.
Usage:
  dpkg-deb -x com.anlai.omnicar_1.0.3_iphoneos-arm64.deb /tmp/omni-root
  python3 scripts/audit_skin_assets.py --root /tmp/omni-root --out /tmp/omni-audit
"""
import argparse,csv,hashlib,struct
from pathlib import Path
p=argparse.ArgumentParser()
p.add_argument('--root',type=Path,required=True)
p.add_argument('--out',type=Path,required=True)
a=p.parse_args()
a.out.mkdir(parents=True,exist_ok=True)
allfiles=sorted(x for x in a.root.rglob('*') if x.is_file())
rows=[]
for f in allfiles:
    if f.suffix.lower()!='.png': continue
    data=f.read_bytes()
    assert data.startswith(b'\x89PNG\r\n\x1a\n'),f
    width,height=struct.unpack('>II',data[16:24])
    rows.append(dict(path=f.relative_to(a.root).as_posix(),filename=f.name,
                     width=width,height=height,bytes=len(data),
                     sha256=hashlib.sha256(data).hexdigest()))
out=a.out/'omnicar_assets_manifest.csv'
with out.open('w',newline='',encoding='utf-8') as fp:
    wr=csv.DictWriter(fp,fieldnames=['path','filename','width','height','bytes','sha256'])
    wr.writeheader();wr.writerows(rows)
print('all_files',len(allfiles),'png_files',len(rows),'manifest',out)
try:
    from PIL import Image,ImageDraw,ImageFont
except ImportError:print('Pillow missing: no contact sheet')
else:
    W=1050;N=3;C=203
    canvas=Image.new('RGB',(W,94+C*((len(rows)+N-1)//N)),'#f3f6fa')
    pen=ImageDraw.Draw(canvas)
    try:font=ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',14)
    except OSError:font=ImageFont.load_default()
    pen.text((20,25),f'OmniCar original package - {len(rows)} PNG icons',font=font,fill='#142d49')
    for i,r in enumerate(rows):
        x=(i%N)*(W//N);y=94+(i//N)*C
        pen.rounded_rectangle((x+7,y+4,x+W//N-7,y+C-5),radius=12,fill='white',outline='#d3dce8')
        with Image.open(a.root/r['path']) as source:icon=source.convert('RGBA')
        icon.thumbnail((112,116),Image.Resampling.LANCZOS)
        canvas.paste(icon,(x+(W//N-icon.width)//2,y+8+(112-icon.height)//2),icon)
        pen.text((x+17,y+145),r['filename'][:36],font=font,fill='#102d4a')
        pen.text((x+17,y+172),f"{r['width']}x{r['height']} | {r['bytes']:,} bytes",font=font,fill='#687b8f')
    sheet=a.out/'omnicar_png_contact_sheet.png';canvas.save(sheet)
    print('contact_sheet',sheet)
