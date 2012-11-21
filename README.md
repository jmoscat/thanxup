Thanxup
-----------------------

Thanxup is an incentivized, user-based social media marketing company.
By awarding user's coupons for visiting businesses, they reward owner's
with social media facebook posts, twitter tweets, yelp reviews, etc.

Installing/Dependencies
-----------------------

First, fork the repository to your github account.

Be sure you have riak:

```
curl -O http://downloads.basho.com.s3-website-us-east-1.amazonaws.com/riak/CURRENT/riak-<version>.tar.gz
tar zxvf riak-<version>.tar.gz
cd riak-<version>
make rel
```

To perform commands on riak, from terminal:

```
riak-<version>/rel/riak/bin/riak <commands>
```

You then need to edit the app.config file to allow search and secondary indexes from this gist https://gist.github.com/7d3729edef3ca6160a32

```
edit: riak-<version>/rel/riak/etc/app.config
```

Commands include start, stop, ping, etc.
https://github.com/basho/riak-ruby-client

Be sure you have postgresql:

```
brew install postgresql
```

Be sure you have qrencode:
```
brew install qrencode
```
http://nycrb.rubyforge.org/qrencoder/

Now clone the repository, in terminal:

```
git clone git@github.com:[your github nickname]/thanxup.git
```

cd into the directory where the files are.
Install any gems with:

```
bundle install
```

Now run rake tasks to setup db:

```
rake db:create
rake db:migrate
```

Thanxup is using unicorn web server. To fire unicorn up:

```
unicorn_rails
```
Then go to http://localhost:8080
