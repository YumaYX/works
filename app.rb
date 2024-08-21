#!/usr/bin/env ruby
require 'json'

def cchild(project, theme)
  name = project.first
  info = project.last

  doc = <<~CHILD
  <div class="cchild">
  <h1 id="#{name}"><a href="#{info["url"]}">#{name}</a></h1>
  <hr />
  <p>#{info["description"]}</p>
  CHILD

  unless info["items"].nil?
    items = info["items"].map { |item| "<li>#{item}</li>" }
    doc = doc + "<ul>"+items.join+"</ul>"
  end

  unless info["image"].nil?
    doc = doc + '<p class="resizeimage"><img src="'+info["image"]+'" /></p>'
  end

  doc + <<~CHILD
  <table>
  <tbody>
  <tr><td>カテゴリ</td><td>#{theme}</td></tr>
  <tr><td>成果物</td><td>#{info["output"]}</td></tr>
  <tr><td>言語</td><td>#{info["lang"]}</td></tr>
  <tr><td>URL</td><td><a class= "url" href="#{info["url"]}">#{info["url"]}</a></td></tr>
  </tbody>
  </table>
  </div>
  CHILD
end

def pparent(theme, projects)
  doc = '<p><b>キーワード：</b>システム管理方法論 / RHEL / Ansible / Ruby / デジタル化 / 自動化 / 自動テスト / 再現性</p>'
  projects.each do |project|
    doc = doc + cchild(project, theme)
  end
  doc
end

doc = <<~'HEAD'
---
layout: custom
---

<!-- head -->
<div class="headfoot">
<h1>作品集 - <a href="https://github.com/YumaYX">YumaSATO</a></h1>

</div>
HEAD

content_data = File.open('app.json') {|j| JSON.load(j)}

content_data.each do |theme, projects|
  doc = doc + pparent(theme, projects)
end

doc = doc + <<~'FOOT'
<!-- foot -->
<div class="headfoot">
<p align="center"><small>&copy; YumaSATO</small></p>
</div>
FOOT

File.write('index.markdown', doc)
