# zepto

Really tiny static site generator

## Usage

1. Install zepto

```
$ gem install zepto
```

1. Create **\_layout** for storing all layouts (with extension **.erb**)
1. Create folder **\_assets** for storing all assets
1. Place all your markdown files inside **content** folder
1. Run

```
$ zepto serve
```

to run the server locally

1. To build run

```
$ zepto build
```

By default zepto will look for 

## For building locally
```
$ gem build zepto
$ gem install ./zepto-VERISON.gem
```

## Customization

You can customize zepto using **zepto.json** in project root

You can specify the following options in **.json** in the project root

| key       | Description             | Value                                       | Default Value   | Required |
|-----------|-------------------------|---------------------------------------------|-----------------|----------|
| ignore    | Files/Folders to ignore | Array of file paths relative to project root| `[]`            | false    |
| assets    | Location of assets      | String                                      | _assets         | false    |
| styles    | Location of styles      | String                                      | _styles         | false    |
| javascript| Location of javascript  | String                                      | _javascript     | false    |
| layout    | Location of layouts     | String                                      | _layout         | false    |

## Pagewise customization

At the top of the page you can attributes between as follows

```
title: "Title of the page"
date: "Date"
layout: "blog.erb"
tags: ["blog", "ruby", "javascript"]
```

Attributes specified at the page level will overwride global attribudes.

1. **tags:** When you speficy a tag you can access blogs group by content using **get_tag** function in your **layout.erb** file which you
can access it as follows

```erb
  <ul>
    <% for | blog | in get_tag("blog") %>
     <li><%=  blog.title %></li>
    <% end %>
  </ul>
```

1. You can get list of all tags by calling **get_tags**
   
```erb
  <ul>
    <% for tag in get_tags %>
     <li><%= tag %></li>
    <% end %>
  </ul>
```

1. **layout:** is used to speficy the layout file. Layout speficied here will override layout speficied global config
1. You can include whatever additional keys here that you need. They are exposed in the **layout.erb**