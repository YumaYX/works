#!/usr/bin/env ruby
require 'json'
require 'date'

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
  doc = ''
  projects.each do |project|
    doc = doc + cchild(project, theme)
  end
  doc
end

def terms
  terms = File.open('terms.json') {|j| JSON.load(j)}
  terms.sort.map do |key, value|
    "<tr><td>#{key}:</td><td>#{value}</td></tr>"
  end
end

keywords = File.open('keywords.json') {|j| JSON.load(j)}

doc = <<~HEAD
---
layout: custom
---

<!-- head -->
<div class="headfoot">
<h1>作品集 - <a href="https://github.com/YumaYX">YumaSATO</a></h1>

<p><b>キーワード：</b>#{keywords.join("、")}</p>

</div>
HEAD

content_data = File.open('app.json') {|j| JSON.load(j)}

content_data.each do |theme, projects|
  doc = doc + pparent(theme, projects)
end

doc = doc + "<div class=\"headfoot\"><table><tbody>#{terms.join}</tbody></table></div>"

today = Date.today
year = today.strftime("%Y")

doc = doc + <<~FOOT
<!-- foot -->
<div class="headfoot">
<p align="center"><small>&copy; #{year} YumaSATO</small></p>
</div>
FOOT

File.write('index.markdown', doc)
