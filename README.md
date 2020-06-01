# zepto

[![Gem Version](https://badge.fury.io/rb/zepto.svg)](https://badge.fury.io/rb/zepto)

Really tiny static site generator

## Usage

1. To install zepto run

```
$ gem install zepto
```

1. Create **\_layout** for storing all layouts (with extension **.erb**)
1. Create folder **\_assets** for storing all assets
1. Place all your markdown files inside **content** folder
1. To build run

```
$ zepto build
```

## Customization

You can customize zepto using **zepto.json** in project root

You can specify the following options in it

| key       | Description             | Value                                       | Default Value   | Required |
|-----------|-------------------------|---------------------------------------------|-----------------|----------|
| assets    | Location of assets      | String                                      | _assets         | false    |
| styles    | Location of styles      | String                                      | _styles         | false    |
| javascript| Location of javascript  | String                                      | _javascript     | false    |
| layout    | Location of layouts     | String                                      | _layout         | false    |

## Pagewise customization

At the top of the page you can attributes between as follows

```
---
title: "Title of the page"
date: "Date"
layout: "blog.erb"
tags: ["blog", "ruby", "javascript"]
---

Content of the page
```

1. **layout:** is used to speficy the layout file
2. **tags:** When you speficy a tag you can access blogs group by content using **get_tag** function in your **layout.erb** file as follows
 
  ```erb
    <ul>
      <% for | blog | in get_tag("blog") %>
      <li><%=  blog.title %></li>
      <% end %>
    </ul>
  ```

3. You can get list of all tags by calling **get_tags**
    
  ```erb
    <ul>
      <% for tag in get_tags %>
      <li><%= tag %></li>
      <% end %>
    </ul>
  ```

4. To get all posts that belong in a particular path

  ```erb
    <ul>
      <% for blog  in get_path("/posts") %>
        <li>
          <a href="<%= blog[:path].delete_suffix("/") %>.html"><%= blog[:title] %></a>
        </li>
      <% end %>
    </ul>
  ```


4. You can include whatever additional keys here that you need. They are exposed in the **layout.erb**