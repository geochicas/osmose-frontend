%import re
<table class="sortable">
<thead>
<tr>
    <th title="source">{{_("source")}}</th>
%# TRANSLATORS: this should be replaced by a abbreviation for subclass
    <th title="level">{{_("level (abbreviation)")}}</th>
    <th>{{_("item")}}</th>
%# TRANSLATORS: this should be replaced by a abbreviation for class
    <th title="class">{{_("class (abbreviation)")}}</th>
%# TRANSLATORS: this should be replaced by a abbreviation for subclass
    <th title="subclass">{{_("subclass (abbreviation)")}}</th>
    <th title="{{_("information on issue")}}">E</th>
    <th title="{{_("position")}}">{{_("position (abbreviation)")}}</th>
    <th>{{_("elements (abbreviation)")}}</th>
    <th>{{_("subtitle")}}</th>
%if opt_date != "-1":
    <th>{{_("date")}}</th>
%end
%if gen == "false-positive":
    <th title="{{_("delete issue")}}">X</th>
%end
</tr>
</thead>
%for res in errors:
<tr>
    <td title="{{res["country"] + "-" + res["analyser"]}}"><a href="?{{!page_args}}source={{res["source"]}}">{{res["source"]}}</a></td>
    <td>{{res["level"]}}</td>
    <td>
        <img src="../images/markers/marker-l-{{res["item"]}}.png" alt="{{res["item"]}}">
        <a href="?{{!page_args}}item={{res["item"]}}">{{res["item"]}}</a>
%        if res["menu"]:
            {{translate.select(res["menu"])}}
%        end
    </td>
    <td>{{res["class"]}}</td>
    <td>{{res["subclass"]}}</td>
%    e = gen if gen in ('error', 'false-positive') else 'error'
    <td title="{{_(u"issue n°")}}{{res["id"]}}"><a href="../{{e}}/{{res["id"]}}">E</a></td>
%    if res["lat"] and res["lon"]:
%        lat = res["lat"]
%        lon = res["lon"]
%        lat_s = "%.2f" % lat
%        lon_s = "%.2f" % lon
    <td><a href="/map/#{{query}}&amp;item={{res["item"]}}&amp;zoom=17&amp;lat={{lat}}&amp;lon={{lon}}&amp;level={{res["level"]}}">{{lon_s}}&nbsp;{{lat_s}}</a></td>
%    else:
    <td></td>
%    end
%    printed_td = False
%    if res["elems"]:
%        elems = res["elems"].split("_")
%        for e in elems:
%            m = re.match(r"([a-z]+)([0-9]+)", e)
%            if m:
%                if not printed_td:
    <td sorttable_customkey="{{"%02d" % ord(m.group(1)[0])}}{{m.group(2)}}">
%                    printed_td = True
%                else:
        &nbsp;
%                end
%                cur_type = m.group(1)
        {{cur_type[0]}}&nbsp;
        <a target="_blank" href="{{main_website}}browse/{{m.group(1)}}/{{m.group(2)}}">{{m.group(2)}}</a>&nbsp;
        &nbsp;
%                if cur_type == "relation":
        <a title="josm" href="../josm_proxy?import?url={{remote_url_read}}/api/0.6/relation/{{m.group(2)}}/full" target="hiddenIframe">(j)</a>
%                else:
        <a title="josm" href="../josm_proxy?load_object?objects={{cur_type[0]}}{{m.group(2)}}" target="hiddenIframe">(j)</a>
%                end
%            end
%        end
%    end
%    if not printed_td:
%        minlat = float(lat) - 0.002
%        maxlat = float(lat) + 0.002
%        minlon = float(lon) - 0.002
%        maxlon = float(lon) + 0.002
    <td>
        <a href="http://localhost:8111/load_and_zoom?left={{minlon}}&amp;bottom={{minlat}}&amp;right={{maxlon}}&amp;top={{maxlat}}">josm</a>
    </td>
%    end
%    if res["subtitle"]:
    <td>{{translate.select(res["subtitle"])}}</td>
%    elif res["title"]:
    <td>{{translate.select(res["title"])}}</td>
%    else:
    <td></td>
%    end
%    if opt_date != "-1":
%        date = str(res["date"])
    <td>{{date[:10]}}&nbsp;{{date[11:16]}}</td>
%    end
%    if gen == "false-positive":
    <td title="{{_("delete issue #%d") % res["id"]}}"><a href="#" class="err_delete" id="delete={{gen}}={{res["id"]}}">X</a></td>
%    end
</tr>
%end
</table>
<script type="text/javascript" src="{{get_url('static', filename='/js/jquery-1.7.2.js')}}"></script>
<script src="{{get_url('static', filename='js/err_delete.js')}}" type="text/javascript"></script>
<iframe id="hiddenIframe" name="hiddenIframe"></iframe>
