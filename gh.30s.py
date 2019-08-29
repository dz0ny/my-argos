#!/usr/bin/env python
# -*- coding: utf-8 -*-

# <bitbar.title>GitHub Notifications</bitbar.title>
# <bitbar.version>v3.0.2</bitbar.version>
# <bitbar.author>Matt Sephton, Keith Cirkel, John Flesch</bitbar.author>
# <bitbar.author.github>flesch</bitbar.author.github>
# <bitbar.desc>GitHub (and GitHub:Enterprise) notifications in your menu bar!</bitbar.desc>
# <bitbar.image>https://i.imgur.com/hW7dw9E.png</bitbar.image>
# <bitbar.dependencies>python</bitbar.dependencies>

import json
import urllib2
import os
import sys
import re
from itertools import groupby

# GitHub.com
github_api_key = os.getenv( 'GITHUB_TOKEN', 'GITHUB_TOKEN' )

# GitHub:Enterprise (optional)
enterprise_api_key = os.getenv( 'GITHUB_ENTERPRISE_TOKEN', 'Enter your GitHub:Enterprise Personal Access Token here...' )
enterprise_api_url = os.getenv( 'GITHUB_ENTERPRISE_API', 'https://github.example.com/api/v3' )

inactive="iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABmJLR0QA/wD/AP+gvaeTAAAEfUlEQVQ4y32V2W/UVRzFP/fe368z7UyXKV0iEDAMLdCyb2F9cGF90rAYKWsiGGLQaGJi4p9AUEmMMS4BNEQDAhZ9MApKAKWlpWr32kqlQinQ6TLTDr/pb+69PpSCGPDcnOS+nPNNvvfkXMHjUQwsAuYBTwAWuA7UAleAvkeJxP2LEFhrAQqAiuzs7K1To9Hp0eiU0LiCccIay507d0x7R8fQ1aud9clk8jBwHIj/SztqKKTEGgMwNxAI7F+xYvlTmzduULNnzSI7O4yUCgBtNIMDg9TW1XHs2HH/ck3t6XQ6/RbQMeah5AP3ebm5uUf27H5p6RuvvyZLS6biZriAwFqDtRaBIDMzSGlJCStXrlRa67K2P9rm+n76goB+ASjpOFhjijKzsj7a+/KeJbt27uCu5+H7PsFgECUlUqlRSoEQgsHBQZSjWLZsKcnk3cmNjU3FWuvvlOOMKKUUxpi969as3r1v3ytCKsmBd97j6BdfAtDT00NNTS3NLS30xnq5VFXNgXcP0tffz/KlSyibMYPm1taSrq6/26WU9U7a9ycUFRVteWHzJhkKhfA8jxvd3VRX11Bf34CQEt/3AchwXbTWeJ5HNDoFYy354/LZvGljoL6+YVs8Hq+UwJKysrJp5eVlYC3Dw8MMDw/jZrgYa9FaI6VESklaayzguC7xeBzP88BaFi6YTzQ6ZR4wS0qlFk6fVpoVCmUhlaT6cg0trW0ox7lv9F86jkPtlToam5qQShKJ5BGNRvOA2Y6bkTGhsKjwXjQs12/cIK01SqnHJl4AqVSKmzd7kGJ0QGFhgaMcd7wjhbACEKOJJCc7G6UUUgj+D1IpwuEwCBBjRwqkNuZGbyx2b7Jg5sxy8nJzGQv8o2gtFBcXM620BACjDbG+vrS1tltqrWvb2zuSyWQSbTTlZTPYWvEioXAYYwxCiPu7E4A1hkh+Hrt2bOPJyZMBGBgc4GrnXwPW2t8dKWVVW3t7a0tL2/wJE8bzS1UVG55/jrlzZnP+wkW+P3OWWGy0ByZOnMiqZ59m5YrlzJk9CyEFSilqr/zKta6uOqVUg8zJy+uOxfqOHvvqhMnJySGQEeBU5WmmTytl/do1OI6LEAKEIBwOsX1rBYsXLhjds5TEYjFOfl3pDQ0NfRYOhxMqGAxijGnv7umZHwwEouvXreVSVTWV33zLhYs/c62rCyHEfa5e9QyRvDyEEKRSKT78+FN+OPPjcWPMfiWl7xitcVy3927Se/PI50cPaa3n7dxewdDQEA2NzbS1d+B5HuLeI43l8Nbt23xy6AgnT1WeS6fTb7uuO5weGUGlPI9gMIgV4tZIKnWpoal5yp+dnU9OnjRJKiU5d/4CWmuEEASCARYvWkhjYzMH3/9g5OxP506kUqlXpVSdRqdJxOMPCjYSiWBHs5dvYUtubm5FVmZmeV9/fwhrJYCU0kQikXgikfgtkUgcllKeBBLa94nH4w839hjyCwrIDofoHxgsVMpZ4Ga4c8W9L8Bae933/TqtTV18oH8gv6CAvt7eh/T/AASr8XlOh+diAAAAAElFTkSuQmCC"
active="iVBORw0KGgoAAAANSUhEUgAAABQAAAAUCAYAAACNiR0NAAAABmJLR0QA/wD/AP+gvaeTAAAEQElEQVQ4y32VS0zUVxTGf/fe/zxk3jBgKiitk4idiohCYppJH0oXrIgJMYJgQuKyaVdNF113YeyiTUq6MKmkxbRJraHUtBssjdCUkGaqQZKJIDSjPDQ4jPNyhuF/bxc4WG30JCd3db6c7zvfOVfw4tgJtAOtwCuAqaqPJNvP/exyBWu7gNeAx8AfwJfABGBEpVoIgTEGIAyc9vl8fZFIZH8kEvGEa2rEo03BQkNM+4+8h1RKggEDCAGwBHxs4JIAkFKitQY45HK5zsdisXe7u7tVc3MzPp8XhGI0HWAi68EYDcYghHie0T0DZywhRAWsNRAIDA0MDBzs6enB4/Fg2zYCw72SJJ5zYrTeauj/YAANAj6USimAuqqqqs/Onj17cGBggHK5TDabRSmFw7JYtt3kbMVLY0uut6wnrZ85duzYO6dOncIYw+DgIHfu3KGrq4ug389NZyPUv4kwGhAvg/Vb5XK5vq6urvfkyZPS4/FQLBZZXl5menqamZkZhNGE3+6m6f2jL6JamSrAmgSORqPRpmg0ijGGfD5PPp/H6XRijMHWhtz8TTZSq/DUCc+xNZV3TCql2pqamqo8Hg9KKaanp0kkEliWhZQSZVkUVxa4/9v3T4YinwE1BhCSwsqi/ufbT/+STqezvra2FiklQgiWlpawbRsp5XYKASu/fM3KrxexSwWEskAqNAID1Ls1gfgVefenr2osIYQRQmz7yufzoZR6xmdCKPTjHHe/O0dmZpLQkQ7cO3dz8PX9tOz00OorM2zSaAOW1nppbW1tu/jAgQMEAgEymQxSymfF0pukb4yT+nuc+j2NdH/xOXtr9mDbNqn19U1jzLK0bfuv+fn5QqFQQGtNNBqlt7cXr9eL1hohxDZ1EBgE1dXV9Pf20Lh7NwbBevoRi4uLaWPMTUtKOXX79u1EIpE4vGvXLqampjhx4gQtLS1MTEwwNjZGKpXaWoWGBo4fP04sFqO5uXlraEoRj8dJJpNxpdSMDAaDy6lU6tLly5e13+/H6XQyOjrKvn376OzsxOFwUNHY6/XS19dHW1sbSimklDx8+JCRkZFiLpf7xuv1ZpXb7UZrPbe6unrY5XJFOjs7mZqa4urVq0xOTpJMJrcBhRB0dHQQDAaRUlIqlbhw4QLXrl37QWt9XkpZtmzbxuFwrBUKhY+Gh4cvaq1b+/v7yeVy3Lp1i7m5OYrFIpWrVKH54MEDhoaGGBkZ+X1zc/MTh8OR39jYQBWLRdxuN0KI+6VS6c/Z2dm9CwsLrzY2NkopJdevX9+6OkLgcrlob29ndnaWwcHBjfHx8R9LpdIHUspF27bJZDJPNz0UClW8Vw30BgKB0zt27HhjfX3dY4yRTzrUoVAok81mb2Sz2SEp5RUgWy6XyWQyW559fi/D4TBer5d0Ol2rlDridDoPVb4AY8y9crkct207nk6n0+FwmP96GOBfN/LUsJn6tmkAAAAASUVORK5CYII="

# Utility Functions

def plural( word, n ):
    return str(n) + ' ' + (word + 's' if n > 1 else word)

def get_dict_subset( thedict, *keys ):
    return dict([ (key, thedict[key]) for key in keys if key in thedict ])

def print_bitbar_line( title, **kwargs ):
    print title + ' | ' + ( ' '.join( [ '{}={}'.format( k, v ) for k, v in kwargs.items() ] ) )

def make_github_request( url, method='GET', data=None, enterprise = False ):
    try:
        api_key = enterprise_api_key if enterprise else github_api_key
        headers = {
            'Authorization': 'token ' + api_key,
            'Accept': 'application/json',
        }
        if data is not None:
            data = json.dumps(data)
            headers['Content-Type'] = 'application/json'
            headers['Contnet-Length'] = len(data)
        request = urllib2.Request( url, headers=headers )
        request.get_method = lambda: method
        response = urllib2.urlopen( request, data )
        return json.load( response ) if response.headers.get('content-length', 0) > 0 else {}
    except Exception:
        return None

def get_notifications( enterprise ):
    url = '%s/notifications' % (enterprise_api_url if enterprise else 'https://api.github.com')
    return make_github_request( url, enterprise=enterprise ) or []

def print_notifications( notifications, enterprise=False ):
    notifications = sorted( notifications, key=lambda notification: notification['repository']['full_name'] )
    for repo, repo_notifications in groupby( notifications, key=lambda notification: notification['repository']['full_name'] ):
        if repo:
            repo_notifications = list( repo_notifications )
            print_bitbar_line( title=repo )
            print_bitbar_line(
                title='{title} - Mark {count} As Read'.format( title=repo, count=len( repo_notifications ) ),
                alternate='true',
                refresh='true',
                bash=__file__,
                terminal='false',
                param1='readrepo',
                param2=repo,
                param3='--enterprise' if enterprise else None
            )
            for notification in repo_notifications:
                formatted_notification = format_notification( notification )
                print_bitbar_line( refresh='true', **get_dict_subset( formatted_notification, 'title', 'href', 'image', 'templateImage' ) )
                print_bitbar_line(
                    refresh='true',
                    title='%s - Mark As Read' % formatted_notification['title'],
                    alternate='true',
                    bash=__file__,
                    terminal='false',
                    param1='readthread',
                    param2=formatted_notification['thread'],
                    param3='--enterprise' if enterprise else None,
                    **get_dict_subset( formatted_notification, 'image', 'templateImage' )
                )

def format_notification( notification ):
    type = notification['subject']['type']
    formatted = {
        'thread': notification['url'],
        'title': notification['subject']['title'].encode('utf-8'),
        'href': notification['subject']['url'],
        'image': 'iVBORw0KGgoAAAANSUhEUgAAAA4AAAAQCAYAAAAmlE46AAAABHNCSVQICAgIfAhkiAAAAAlwSFlzAAALEwAACxMBAJqcGAAAA',
    }
    if len(formatted['title']) > 90:
        formatted['title'] = formatted['title'][:79] + '…'
    formatted['title'] = formatted['title'].replace('|','-')
    latest_comment_url = notification.get( 'subject', {} ).get( 'latest_comment_url', None )
    typejson = make_github_request( formatted['href'] )
    if latest_comment_url:
        formatted['href'] = ( make_github_request( latest_comment_url ) or {} ).get( 'html_url', formatted['href'] )
    # Try to hack a web-viewable URL if the last check failed
    if formatted['href']:
        formatted['href'] = re.sub( 'api\.|api/v3/|repos/', '', re.sub( '(pull|commit)s', ur'\1', formatted['href'] ) )
    if (type == 'PullRequest'):
        if typejson and typejson['merged']:
            formatted['image'] += 'SpJREFUKJG9kkFOwmAQhb+ZQiVx5xm4hIlncEF7jLZuWSjSeAJsvQUY4xkMHsCtcU9MXBmwJsy4EWgFEt34VpP55mX+eflhj9KoGO5jAK00LmOwoZiaYIPRbXaXRsVQRC6BvWZJ4uLJRI6DcKlUMsVl/G0CwIw3UR8V4+QKxFd9BbfDqiP6buo1sB5QjgTJ07i8aPTFgvNFa/7i7fYzaL+YpEN3zwGux4mY2QmAm6db783i0rO4bGyrh7OL66a0Bigm6d5gGkYz3brvV8a/SjeF/dPGJLrpmTMDXs/i4vTnQNYrInNm5szqvIVYbiJdCV1Z6ANwXze6em4i3SBcqi+CNVeAIFxq9dkR0+07HfHVz6rzlsLAK5keUCEu/R0hDD7C+SME6A7+Z30BqF2G+GPLjSUAAAAASUVORK5CYII='
        elif typejson and typejson['state'] == 'closed':
            formatted['image'] += 'Q9JREFUKJG9kjFOw0AQRd9sbAiiQOIMqWJfAInOPULANehTQIjFCbgHFS1eKhR6cDpEbyHRmljyDpWVTWJbSsOvRvvm72i+BjpkI2ZdDIBszNVzTG7HvGcx543JxmifT7KIj4FyUlaYcMjcKI8Id17Pj8JDknMvrD4zoriwRg4OMaKtU44FUhtz6z8aFW7KkC9X82mESbJghpICJDkiyimAwvV2EDG6uZMfThs3TeFYB8miP1XjFb0pdhp31cro/muijbjAUTjDtx1zttnwEnGJo8BR+DxQSAcwWv5i9vd4BZ58Yy2kgTIqq3VuAMoKEx4htCQrijaX5fMAYRoOmbMEJ0y2lhGmZcgbNdDGd9Uf3M1iNlKZZGMAAAAASUVORK5CYII='
        else:
            formatted['image'] += 'TJJREFUKJG9krFOAlEQRe/MLpqHnd/ATyBWsLWF+hcLPYXibvwCE/gLC2MNVrD7AbbGnpjYboBlro2QXWATabzVy5x338ydPKBC4awTVTEA8Huz9i1FI5gZBINh6+0lnHUiEXkAUGmWMGm/c7Fues4pLU9IPv+aAABm9i2qT6Pm+BECbuoqpnZWW4lmmRLG3ZdV9VyAOEyD+1JdVO4yqX+ua7UPofRHrUlEMgaA4cVYALkEACF6e/N2k4DdJCh1Ky7nENftyVACo9akcjElox3I9yfjsdoaVfFPHbtpcG2GOUy/wjS42r0QTjs3ZpibYV7kPmkxVuuGOKfIl1MAr0WjqMRcrBqec8oCVwDwnNOFnwugezkJ4+ZnFbkPeANanpwsAQr7+2m8Qab1FKcAeYgfqR/3P4pMOYR15QAAAABJRU5ErkJggg=='
        if typejson and typejson.get( 'user', {} ).get( 'login', None ):
            formatted['title'] += ' (by @{})'.format(typejson['user']['login'])
    elif (type == 'RepositoryInvitation'):
        formatted['image'] = 'iVBORw0KGgoAAAANSUhEUgAAAA4AAAAKCAYAAACE2W/HAAAAAXNSR0IArs4c6QAAAM1JREFUKBWVkD0OQUEUhcdv/ASJn55SyxLoVBJq8tZjBRQsgkZiAQoqOiQ2oFc935nMvLxEXsRJPufOufe+kTHGmBeEf3Jg3i4t8IwOP6QZzeoi+3PFt1BRkKAq+Q4uEKbdUA+/wxm6LoubshPcoO8b9lp3GOMPGPomPoInqOcV/VUfyKfwhsChegJxfS3O6R5hALpFqFY2A69osUyygT3UQOpAWwVSpt4aShAt6lWXkIUk5WiswL5qiqIODdBz6+ZirM67cwFvulwfaH0AC7M1lHL62U4AAAAASUVORK5CYII=';
        formatted['templateImage'] = formatted.pop('image');
        formatted['href'] = 'https://github.com/{}/invitations'.format(notification['repository']['full_name'])
    elif (type == 'Issue'):
        if typejson and typejson['state'] == 'closed':
            formatted['image'] += 'YpJREFUKJGdkj9I23EQxT93SZrJQYNQ6Bo65BtQcHRpSeyUuQqNWx2ti7qJRpqhUxGX0lGhlXQ0uJhfU7cOLm3+QKCzoIjoJpp8z0HT/BpJBd90HO/dvTsePBLS36iM8Uw6vANyQNJ7RJU/wG7nmo1XLY7uCStp8uL5BJwgbJtRU8E8jImR98qoGHPZBjsSFhlsCRQjCQovD2iHhx5OEDu/ZF2E5Y4wLn/tXdMy5WO2zkqXHKQxgEy95+y7Y1KMXwogbeaBk0iCwqBn7DteAJym+NmBnSiAF3IK2/32wiIVqoGjYE1GRMlGARSSZtQGbZtq8CNwFBBWDUxgJjqI3I9Mg7XAgRoXmSYlACqOWuAG39ePimNB7+oyxuzhBLEwIUhj3c92sZckLsaSAvg2m14ZPb98eGs8ThFlqBcAx4wJX8T4cGasvm5yFRaUUjwZUd4bLKow/W/kbsWfgTMxvorxmwhtjHEPbxSGEd5many7F/JqiqdemceT88rzu3ZLoWywma1z/NA5/8UNNkSJCdaYQF4AAAAASUVORK5CYII='
        else:
            formatted['image'] += 'ZxJREFUKJGdkjFoU2EUhb97k9jNRzEFoWvJVHXoZCqIaQaH7JaUbtpi2zc4ORWJYKGTYJLBroFaiGPo0hBwyAOhU51Cd8EOOid53uugL4SnkOK3/dx7OPccfvhPZPqxHZUWc0gIUjFs6c/CJdDBtN580P36lzCM1jZ+mr9HuFKkJfgXABO9i/mmqOTd7VlztXcyEYbR2oabtFx5kx+Oa7VHn+LpS7bOV3K5UfBaTF+6WLW52juR7ai0mDEGovq2WezuJ8t7UdkBGsXu5KqdfvlQhOeeGRc0h4QIV/nhuDarkIVgft+xHxJnQwWpKNJKn/cvasvtkcCxuFTUsKWkiOsgrhcoBb2uIE1W4NKRO8DH6cF0KSnLewYDBTqGb26dr+Sm53tR2ZNmE8LTx3O4V9XpKKZ1FV24MZyf2aoH8YE5garXBWC3X1oX12NXO8zfvPWqttwepZ08iA9wXqDypFE8a09y7PZL64geCXx37IO4XiSZcK/+dso8bRTP2pD65DufH96WOBuKSwWlAGD4QJ2Oqtff3e99mxVnJr8AXSGi02ni0+YAAAAASUVORK5CYII='
    elif (type == 'Commit'):
        formatted['image'] += 'HhJREFUKJHl0LEKwkAQBNCH3yIaf05S+VUqmh8ykFoUYn8WbnEc8a7XgYVlmNkdhv/EDgNmvHDFtmXq8ETCiFvsD2xqxksI9xnXB3cqxamYceHgVOpWC6JUi/QNQxj7jDsEd6wZ83KmLOId69bXzqekOeas0eiv4g3q4SY7NY1R2gAAAABJRU5ErkJggg=='
        formatted['templateImage'] = formatted.pop('image')
    elif (type == 'Release'):
        formatted['image'] += 'JdJREFUKJGl0DsKwkAUBdDTRgvFHbgmNyLY+QWzKxM/kK2kSKc70MIIQ0ziqBceA/dxinn8mSkKVMGUmH+CBWaNboQjdn2wqt97Pa8kNd5+C0O86YNdSZC34RLjCJxhHZYLXDCIxKuwTHGOwBNcm2WKUw9OcMCybZl6XjHpQOs30cB5gKNQiDPPP0WjV/a4aVwxNsNfUGce7P8k4XgVPSYAAAAASUVORK5CYII='
        formatted['templateImage'] = formatted.pop('image')
    return formatted

if len(sys.argv) > 1:
    command = sys.argv[1]
    args = sys.argv[2:]
    enterprise=False
    if ('--enterprise' in args):
        enterprise=True
        args.remove( '--enterprise' )
    if command == 'readrepo':
        url = '%s/repos/%s/notifications' % (enterprise_api_url if enterprise else 'https://api.github.com', args[0])
        print 'Marking %s as read' % url
        make_github_request( url=url, method='PUT', data={}, enterprise=enterprise )
    elif command == 'readthread':
        url = args[0]
        print 'Marking %s as read' % url
        make_github_request( url=url, method='PATCH', data={}, enterprise=enterprise )

else:
    is_github_defined = len( github_api_key ) == 40
    is_github_enterprise_defined = len( enterprise_api_key ) == 40
    github_notifications = get_notifications( enterprise=False ) if is_github_defined else []
    enterprise_notifications = get_notifications( enterprise=True ) if is_github_enterprise_defined else []
    has_notifications = len( github_notifications ) + len( enterprise_notifications )
    image = active if has_notifications else inactive

    if (has_notifications):
        print_bitbar_line(
            title='',
            image=image
        )
        print '---'
    else:
        print_bitbar_line(
            title='',
            image=image
        )
        print '---'

    print_bitbar_line( title='Refresh', refresh='true' )

    if is_github_defined:
        if len( github_notifications ):
            print_bitbar_line(
                title=( u'GitHub \u2014 %s' % plural( 'notification', len( github_notifications ) ) ).encode( 'utf-8' ),
                href='https://github.com/notifications',
            )
            print_notifications( github_notifications )
        else:
            print_bitbar_line(
                title=u'GitHub \u2014 No new notifications'.encode( 'utf-8' ),
                href='https://github.com',
            )

    if is_github_enterprise_defined:
        if len( enterprise_notifications ):
            if is_github_defined:
                print '---'
            print_bitbar_line(
                title=( u'GitHub:Enterprise \u2014 %s' % plural( 'notification', len( enterprise_notifications ) ) ).encode( 'utf-8' ),
                href='%s/notifications' % re.sub( '/api/v3', '',  enterprise_api_url ),
            )
            print_notifications( enterprise_notifications, enterprise=True )
        else:
            print '---'
            print_bitbar_line(
                title=u'GitHub:Enterprise \u2014 No new notifications',
            )
