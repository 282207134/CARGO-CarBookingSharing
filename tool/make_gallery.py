"""Regenerate contact sheets and the design-to-screen index. Requires Pillow."""
import json
import re
from pathlib import Path
from PIL import Image, ImageDraw

ROOT = Path(__file__).resolve().parents[1]
NODES = ['0:2', '0:31', '0:109', '0:191', '0:223', '0:284', '0:316', '0:355',
         '0:394', '0:452', '0:543', '0:591', '0:674', '0:742', '0:919', '0:1040',
         '0:1232', '0:1302', '0:1390', '0:1416', '0:1649', '0:1784', '0:1900',
         '0:2066', '0:2246', '0:2349', '0:2439', '0:2539', '0:2552', '0:2627']
PAGES = re.findall(r"^\s*(\w+)\('([^']+)'\)[,;]", (ROOT / 'lib/core/app_state.dart').read_text(), re.M)
assert len(PAGES) == len(NODES) == 30

for folder in ['screenshots', 'design-reference']:
    for start in [0, 10, 20]:
        sheet = Image.new('RGB', (1250, 1120), '#e7eaf0')
        draw = ImageDraw.Draw(sheet)
        for j in range(10):
            i = start + j
            name, title = PAGES[i]
            filename = f'{i+1:02}-{name}.png' if folder == 'screenshots' else f'{i+1:02}.png'
            with Image.open(ROOT / 'docs' / folder / filename) as source:
                preview = source.convert('RGB')
                preview.thumbnail((235, 509))
                x, y = (j % 5) * 250 + 7, (j // 5) * 560 + 30
                sheet.paste(preview, (x, y))
                draw.text((x, y - 20), f'{i+1:02} {title[:29]}', fill='#222b45')
        sheet.save(ROOT / 'docs' / folder / f'overview-{start+1:02}.jpg', quality=90)

entries = []
lines = ['# 页面与截图清单', '',
         'Pixso 文件：**CARGO - Car Booking & Sharing App**。已枚举全部分类，仅有 **👁 Components Overview（0:1）**。以下 30 页均已实现；展开状态复用相同功能组件，输入状态使用真实 Flutter 表单。', '',
         '运行图由 Android 模拟器中的 Flutter 截图测试生成；原稿图由 Pixso 直接导出。', '',
         '| 编号 | 页面 | Pixso 节点 | Flutter 运行图 | 原稿图 |',
         '| --- | --- | --- | --- | --- |']
for i, ((name, title), node) in enumerate(zip(PAGES, NODES), 1):
    screenshot = f'screenshots/{i:02}-{name}.png'
    reference = f'design-reference/{i:02}.png'
    assert (ROOT / 'docs' / screenshot).exists()
    assert (ROOT / 'docs' / reference).exists()
    lines.append(f'| {i:02} | {title} | `{node}` | [查看]({screenshot}) | [查看]({reference}) |')
    entries.append(dict(number=i, page=name, title=title, pixsoNode=node,
                        screenshot=screenshot, reference=reference))
(ROOT / 'docs/页面清单.md').write_text('\n'.join(lines) + '\n')
(ROOT / 'docs/design-reference/screen-map.json').write_text(json.dumps({
    'document': 'CARGO - Car Booking & Sharing App',
    'page': {'id': '0:1', 'name': '👁 Components Overview'},
    'designSize': {'width': 375, 'height': 812}, 'screens': entries,
}, ensure_ascii=False, indent=2) + '\n')
print('Generated 6 contact sheets and mapped all 30 screens.')
