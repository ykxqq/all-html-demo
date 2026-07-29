#!/usr/bin/env bash
# 用 shell + zip 直接拼装 PPTX
# 每页: 1 张全屏图片 (1920x1080 PNG) + 1 个可编辑文本框 (页码 + 标题)
# 这是一个"图片型可编辑 PPTX"：图片作为底图，文字层可双击编辑
set -e

cd "/Users/smzdm/Library/Application Support/TRAE SOLO CN/ModularData/ai-agent/work-mode-projects/6a599e86833d142168c5be1b/smzdm-burberry-618"

OUT=SMZDM_BURBERRY_618_case.pptx
WORK=_pptx_build
rm -rf "$WORK" && mkdir -p "$WORK"

# 18 页元数据: 序号 | 文件名 | 标题 | 副标题
cat > _pages.tsv <<'EOF'
1	01-cover	Cover	破局奢侈品夏季运营魔咒
2	02-toc	Contents	目录
3	03-part-one	Part One	品牌痛点
4	04-pain-point	Pain Point	奢侈品夏季运营的"不可能"
5	05-part-two	Part Two	核心策略
6	06-three-step	Solution	三板斧解法
7	07-audience	Audience	人群锚定
8	08-content	Content	内容翻译
9	09-loop	Loop	链路闭环
10	10-part-three	Part Three	合作亮点
11	11-highlights	Highlights	三大合作亮点
12	12-data-driven	Selection	数据驱动选品力
13	13-insight	Insight	消费洞察深度化
14	14-value-perception	Value	专业内容构建"值"认知
15	15-part-four	Part Four	范式沉淀
16	16-growth-model	Model	可复制的奢品增长模型
17	17-industry-value	Industry	行业价值
18	18-thank-you	Thank You	THANK YOU
EOF

N=$(wc -l < _pages.tsv)

# 准备目录结构
mkdir -p "$WORK/_rels" "$WORK/ppt/_rels" "$WORK/ppt/slides/_rels" "$WORK/ppt/slideLayouts/_rels" "$WORK/ppt/slideMasters/_rels" "$WORK/ppt/media" "$WORK/ppt/theme" "$WORK/docProps"

# 复制所有图片
i=1
while IFS=$'\t' read -r num slug title sub; do
  cp "_pdf_png/${slug}.png" "$WORK/ppt/media/image${i}.png"
  i=$((i+1))
done < _pages.tsv

# [Content_Types].xml
cat > "$WORK/[Content_Types].xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Types xmlns="http://schemas.openxmlformats.org/package/2006/content-types">
<Default Extension="rels" ContentType="application/vnd.openxmlformats-package.relationships+xml"/>
<Default Extension="xml" ContentType="application/xml"/>
<Default Extension="png" ContentType="image/png"/>
<Override PartName="/ppt/presentation.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.presentation.main+xml"/>
EOF
i=1
while IFS=$'\t' read -r num slug title sub; do
  cat >> "$WORK/[Content_Types].xml" <<EOF
<Override PartName="/ppt/slides/slide${i}.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slide+xml"/>
EOF
  i=$((i+1))
done < _pages.tsv
cat >> "$WORK/[Content_Types].xml" <<'EOF'
<Override PartName="/ppt/slideLayouts/slideLayout1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideLayout+xml"/>
<Override PartName="/ppt/slideMasters/slideMaster1.xml" ContentType="application/vnd.openxmlformats-officedocument.presentationml.slideMaster+xml"/>
<Override PartName="/ppt/theme/theme1.xml" ContentType="application/vnd.openxmlformats-officedocument.theme+xml"/>
<Override PartName="/docProps/core.xml" ContentType="application/vnd.openxmlformats-package.core-properties+xml"/>
<Override PartName="/docProps/app.xml" ContentType="application/vnd.openxmlformats-officedocument.extended-properties+xml"/>
</Types>
EOF

# _rels/.rels
cat > "$WORK/_rels/.rels" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/officeDocument" Target="ppt/presentation.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/package/2006/relationships/metadata/core-properties" Target="docProps/core.xml"/>
<Relationship Id="rId3" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/extended-properties" Target="docProps/app.xml"/>
</Relationships>
EOF

# docProps
cat > "$WORK/docProps/core.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<cp:coreProperties xmlns:cp="http://schemas.openxmlformats.org/package/2006/metadata/core-properties" xmlns:dc="http://purl.org/dc/elements/1.1/" xmlns:dcterms="http://purl.org/dc/terms/" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
<dc:title>什么值得买 × BURBERRY 618 合作案例</dc:title>
<dc:creator>SMZDM</dc:creator>
<cp:lastModifiedBy>SMZDM</cp:lastModifiedBy>
<dcterms:created xsi:type="dcterms:W3CDTF">2026-07-17T00:00:00Z</dcterms:created>
<dcterms:modified xsi:type="dcterms:W3CDTF">2026-07-17T00:00:00Z</dcterms:modified>
</cp:coreProperties>
EOF

cat > "$WORK/docProps/app.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Properties xmlns="http://schemas.openxmlformats.org/officeDocument/2006/extended-properties" xmlns:vt="http://schemas.openxmlformats.org/officeDocument/2006/docPropsVTypes">
<Application>Hua Shu Design</Application>
<Company>SMZDM</Company>
</Properties>
EOF

# ppt/presentation.xml - 16:9 宽屏 (EMU: 12192000 x 6858000)
cat > "$WORK/ppt/presentation.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:presentation xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
<p:sldMasterIdLst><p:sldMasterId id="1" r:id="rId1"/></p:sldMasterIdLst>
EOF
echo -n '<p:sldIdLst>' >> "$WORK/ppt/presentation.xml"
i=1
while IFS=$'\t' read -r num slug title sub; do
  echo -n "<p:sldId id=\"${i}\" r:id=\"rId${i}\"/>" >> "$WORK/ppt/presentation.xml"
  i=$((i+1))
done < _pages.tsv
cat >> "$WORK/ppt/presentation.xml" <<'EOF'
</p:sldIdLst>
<p:sldSz cx="12192000" cy="6858000" type="screen16x9"/>
<p:notesSz cx="6858000" cy="9144000"/>
</p:presentation>
EOF

# ppt/_rels/presentation.xml.rels
cat > "$WORK/ppt/_rels/presentation.xml.rels" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="slideMasters/slideMaster1.xml"/>
EOF
i=1
while IFS=$'\t' read -r num slug title sub; do
  cat >> "$WORK/ppt/_rels/presentation.xml.rels" <<EOF
<Relationship Id="rId${i}" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slide" Target="slides/slide${i}.xml"/>
EOF
  i=$((i+1))
done < _pages.tsv
echo '</Relationships>' >> "$WORK/ppt/_rels/presentation.xml.rels"

# 主题 theme
cat > "$WORK/ppt/theme/theme1.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<a:theme xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" name="Office Theme"><a:themeElements><a:clrScheme name="Office"><a:dk1><a:sysClr val="windowText" lastClr="000000"/></a:dk1><a:lt1><a:sysClr val="window" lastClr="FFFFFF"/></a:lt1><a:dk2><a:srgbClr val="44546A"/></a:dk2><a:lt2><a:srgbClr val="E7E6E6"/></a:lt2><a:accent1><a:srgbClr val="C4A77D"/></a:accent1><a:accent2><a:srgbClr val="3D2B1F"/></a:accent2><a:accent3><a:srgbClr val="B8956E"/></a:accent3><a:accent4><a:srgbClr val="F5EFE6"/></a:accent4><a:accent5><a:srgbClr val="C00000"/></a:accent5><a:accent6><a:srgbClr val="FFFF00"/></a:accent6><a:hlink><a:srgbClr val="0563C1"/></a:hlink><a:folHlink><a:srgbClr val="954F72"/></a:folHlink></a:clrScheme><a:fontScheme name="Office"><a:majorFont><a:latin typeface="Playfair Display"/><a:ea typeface=""/><a:cs typeface=""/></a:majorFont><a:minorFont><a:latin typeface="Helvetica Neue"/><a:ea typeface=""/><a:cs typeface=""/></a:minorFont></a:fontScheme><a:fmtScheme name="Office"><a:fillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:fillStyleLst><a:lnStyleLst><a:ln w="6350" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln><a:ln w="12700" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln><a:ln w="19050" cap="flat" cmpd="sng" algn="ctr"><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:ln></a:lnStyleLst><a:effectStyleLst><a:effectStyle><a:effectLst/></a:effectStyle><a:effectStyle><a:effectLst/></a:effectStyle><a:effectStyle><a:effectLst/></a:effectStyle></a:effectStyleLst><a:bgFillStyleLst><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill><a:solidFill><a:schemeClr val="phClr"/></a:solidFill></a:bgFillStyleLst></a:fmtScheme></a:themeElements></a:theme>
EOF

# slide master
cat > "$WORK/ppt/slideMasters/slideMaster1.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldMaster xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main"><p:cSld><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="0" cy="0"/><a:chOff x="0" y="0"/><a:chExt cx="0" cy="0"/></a:xfrm></p:grpSpPr></p:spTree></p:cSld><p:clrMap bg1="lt1" tx1="dk1" bg2="lt2" tx2="dk2" accent1="accent1" accent2="accent2" accent3="accent3" accent4="accent4" accent5="accent5" accent6="accent6" hlink="hlink" folHlink="folHlink"/><p:sldLayoutIdLst><p:sldLayoutId id="1" r:id="rId1"/></p:sldLayoutIdLst></p:sldMaster>
EOF

cat > "$WORK/ppt/slideMasters/_rels/slideMaster1.xml.rels" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/theme" Target="../theme/theme1.xml"/>
</Relationships>
EOF

# slideLayout1
cat > "$WORK/ppt/slideLayouts/slideLayout1.xml" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sldLayout xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main" type="blank" preserve="1"><p:cSld name="Blank"><p:spTree><p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr><p:grpSpPr/></p:spTree></p:cSld></p:sldLayout>
EOF

cat > "$WORK/ppt/slideLayouts/_rels/slideLayout1.xml.rels" <<'EOF'
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideMaster" Target="../slideMasters/slideMaster1.xml"/>
</Relationships>
EOF

# === 18 张 slide ===
# 每张含：1) 全屏图片底图 2) 一个可编辑的标题文本框（双击可改）
i=1
while IFS=$'\t' read -r num slug title sub; do
  cat > "$WORK/ppt/slides/slide${i}.xml" <<XML
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<p:sld xmlns:a="http://schemas.openxmlformats.org/drawingml/2006/main" xmlns:r="http://schemas.openxmlformats.org/officeDocument/2006/relationships" xmlns:p="http://schemas.openxmlformats.org/presentationml/2006/main">
<p:cSld><p:spTree>
<p:nvGrpSpPr><p:cNvPr id="1" name=""/><p:cNvGrpSpPr/><p:nvPr/></p:nvGrpSpPr>
<p:grpSpPr/>
<p:pic><p:nvPicPr><p:cNvPr id="2" name="BgImage"/><p:cNvPicPr/></p:nvPicPr><p:blipFill><a:blip r:embed="rId1"/><a:stretch><a:fillRect/></a:stretch></p:blipFill><p:spPr><a:xfrm><a:off x="0" y="0"/><a:ext cx="12192000" cy="6858000"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom></p:spPr></p:pic>
<p:sp><p:nvSpPr><p:cNvPr id="3" name="Title"/><p:cNvSpPr txBox="1"/><p:nvSpPr/></p:nvSpPr><p:spPr><a:xfrm><a:off x="457200" y="6400800"/><a:ext cx="11277600" cy="304800"/></a:xfrm><a:prstGeom prst="rect"><a:avLst/></a:prstGeom><a:noFill/></p:spPr><p:txBody><a:bodyPr wrap="square" lIns="0" tIns="0" rIns="0" bIns="0" anchor="ctr"/><a:lstStyle/><a:p><a:pPr algn="l"/><a:r><a:rPr lang="zh-CN" sz="1200" b="1"><a:solidFill><a:srgbClr val="C4A77D"/></a:solidFill><a:latin typeface="Helvetica Neue"/><a:ea typeface="Microsoft YaHei"/></a:rPr><a:t>${num} · ${title}</a:t></a:r></a:p></p:txBody></p:sp>
</p:spTree></p:cSld>
</p:sld>
XML
  cat > "$WORK/ppt/slides/_rels/slide${i}.xml.rels" <<EOF
<?xml version="1.0" encoding="UTF-8" standalone="yes"?>
<Relationships xmlns="http://schemas.openxmlformats.org/package/2006/relationships">
<Relationship Id="rId1" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/image" Target="../media/image${i}.png"/>
<Relationship Id="rId2" Type="http://schemas.openxmlformats.org/officeDocument/2006/relationships/slideLayout" Target="../slideLayouts/slideLayout1.xml"/>
</Relationships>
EOF
  i=$((i+1))
done < _pages.tsv

# 打包为 zip
cd "$WORK"
rm -f "../$OUT"
zip -r "../$OUT" . -q
cd ..
ls -lh "$OUT"
echo "=== done ==="
