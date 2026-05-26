<?xml version="1.0" encoding="UTF-8"?>
<drawing version="7">
    <attr value="spartan6" name="DeviceFamilyName">
        <trait delete="all:0" />
        <trait editname="all:0" />
        <trait edittrait="all:0" />
    </attr>
    <netlist>
        <signal name="ad_clk" />
        <signal name="ad_out(7:0)" />
        <signal name="da_clk" />
        <signal name="da_data(7:0)" />
        <signal name="XLXN_5(7:0)" />
        <signal name="XLXN_6(7:0)" />
        <signal name="XLXN_7(7:0)" />
        <signal name="XLXN_8(7:0)" />
        <signal name="XLXN_9(7:0)" />
        <signal name="XLXN_10(7:0)" />
        <signal name="XLXN_11(7:0)" />
        <signal name="XLXN_13(1:0)" />
        <signal name="XLXN_14(1:0)" />
        <signal name="XLXN_15(1:0)" />
        <signal name="XLXN_16" />
        <signal name="key1" />
        <signal name="XLXN_18" />
        <signal name="key2" />
        <signal name="XLXN_20" />
        <signal name="XLXN_21" />
        <signal name="sys_clk" />
        <signal name="XLXN_23" />
        <signal name="XLXN_24" />
        <signal name="sys_rst_n" />
        <signal name="XLXN_26" />
        <signal name="XLXN_27" />
        <signal name="ad_data(7:0)" />
        <port polarity="Output" name="ad_clk" />
        <port polarity="Output" name="ad_out(7:0)" />
        <port polarity="Output" name="da_clk" />
        <port polarity="Output" name="da_data(7:0)" />
        <port polarity="Input" name="key1" />
        <port polarity="Input" name="key2" />
        <port polarity="Input" name="sys_clk" />
        <port polarity="Input" name="sys_rst_n" />
        <port polarity="Input" name="ad_data(7:0)" />
        <blockdef name="counter">
            <timestamp>2024-11-16T7:35:49</timestamp>
            <rect width="256" x="64" y="-128" height="128" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <rect width="64" x="320" y="-108" height="24" />
            <line x2="384" y1="-96" y2="-96" x1="320" />
        </blockdef>
        <blockdef name="ad_wave_rec">
            <timestamp>2024-11-16T7:35:4</timestamp>
            <rect width="256" x="64" y="-192" height="192" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="384" y1="-160" y2="-160" x1="320" />
            <rect width="64" x="320" y="-44" height="24" />
            <line x2="384" y1="-32" y2="-32" x1="320" />
        </blockdef>
        <blockdef name="da_wave_send">
            <timestamp>2024-11-16T7:35:46</timestamp>
            <rect width="288" x="64" y="-512" height="512" />
            <line x2="0" y1="-480" y2="-480" x1="64" />
            <line x2="0" y1="-416" y2="-416" x1="64" />
            <rect width="64" x="0" y="-364" height="24" />
            <line x2="0" y1="-352" y2="-352" x1="64" />
            <rect width="64" x="0" y="-300" height="24" />
            <line x2="0" y1="-288" y2="-288" x1="64" />
            <rect width="64" x="0" y="-236" height="24" />
            <line x2="0" y1="-224" y2="-224" x1="64" />
            <rect width="64" x="0" y="-172" height="24" />
            <line x2="0" y1="-160" y2="-160" x1="64" />
            <rect width="64" x="0" y="-108" height="24" />
            <line x2="0" y1="-96" y2="-96" x1="64" />
            <rect width="64" x="0" y="-44" height="24" />
            <line x2="0" y1="-32" y2="-32" x1="64" />
            <line x2="416" y1="-480" y2="-480" x1="352" />
            <rect width="64" x="352" y="-268" height="24" />
            <line x2="416" y1="-256" y2="-256" x1="352" />
            <rect width="64" x="352" y="-44" height="24" />
            <line x2="416" y1="-32" y2="-32" x1="352" />
        </blockdef>
        <blockdef name="rom">
            <timestamp>2024-11-16T7:37:48</timestamp>
            <rect width="320" x="32" y="32" height="172" />
            <line x2="32" y1="80" y2="80" style="linewidth:W" x1="0" />
            <line x2="352" y1="64" y2="64" style="linewidth:W" x1="384" />
            <line x2="32" y1="128" y2="128" x1="0" />
        </blockdef>
        <blockdef name="rom_saw">
            <timestamp>2024-11-16T7:38:30</timestamp>
            <rect width="348" x="32" y="32" height="144" />
            <line x2="32" y1="80" y2="80" style="linewidth:W" x1="0" />
            <line x2="384" y1="64" y2="64" style="linewidth:W" x1="416" />
            <line x2="32" y1="128" y2="128" x1="0" />
        </blockdef>
        <blockdef name="rom_squ">
            <timestamp>2024-11-16T7:39:9</timestamp>
            <rect width="332" x="32" y="32" height="156" />
            <line x2="32" y1="80" y2="80" style="linewidth:W" x1="0" />
            <line x2="368" y1="64" y2="64" style="linewidth:W" x1="400" />
            <line x2="32" y1="144" y2="144" x1="0" />
        </blockdef>
        <blockdef name="rom_tri">
            <timestamp>2024-11-16T7:39:48</timestamp>
            <rect width="332" x="32" y="32" height="172" />
            <line x2="32" y1="80" y2="80" style="linewidth:W" x1="0" />
            <line x2="368" y1="64" y2="64" style="linewidth:W" x1="400" />
            <line x2="32" y1="160" y2="160" x1="0" />
        </blockdef>
        <blockdef name="bufg">
            <timestamp>2000-1-1T10:10:10</timestamp>
            <line x2="64" y1="-64" y2="0" x1="64" />
            <line x2="64" y1="-32" y2="-64" x1="128" />
            <line x2="128" y1="0" y2="-32" x1="64" />
            <line x2="128" y1="-32" y2="-32" x1="224" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
        </blockdef>
        <blockdef name="ibufg">
            <timestamp>2009-3-20T10:10:10</timestamp>
            <line x2="64" y1="0" y2="-64" x1="64" />
            <line x2="64" y1="-32" y2="0" x1="128" />
            <line x2="128" y1="-64" y2="-32" x1="64" />
            <line x2="128" y1="-32" y2="-32" x1="224" />
            <line x2="64" y1="-32" y2="-32" x1="0" />
        </blockdef>
        <block symbolname="counter" name="XLXI_1">
            <blockpin signalname="XLXN_16" name="clk" />
            <blockpin signalname="sys_rst_n" name="rst_n" />
            <blockpin signalname="XLXN_14(1:0)" name="q(1:0)" />
        </block>
        <block symbolname="counter" name="XLXI_2">
            <blockpin signalname="XLXN_18" name="clk" />
            <blockpin signalname="sys_rst_n" name="rst_n" />
            <blockpin signalname="XLXN_13(1:0)" name="q(1:0)" />
        </block>
        <block symbolname="ad_wave_rec" name="XLXI_3">
            <blockpin signalname="XLXN_24" name="clk" />
            <blockpin signalname="sys_rst_n" name="rst_n" />
            <blockpin signalname="ad_data(7:0)" name="ad_data(7:0)" />
            <blockpin signalname="ad_clk" name="ad_clk" />
            <blockpin signalname="ad_out(7:0)" name="ad_out(7:0)" />
        </block>
        <block symbolname="da_wave_send" name="XLXI_4">
            <blockpin signalname="XLXN_23" name="clk" />
            <blockpin signalname="sys_rst_n" name="rst_n" />
            <blockpin signalname="XLXN_6(7:0)" name="rd_data(7:0)" />
            <blockpin signalname="XLXN_8(7:0)" name="rd_data2(7:0)" />
            <blockpin signalname="XLXN_9(7:0)" name="rd_data3(7:0)" />
            <blockpin signalname="XLXN_10(7:0)" name="rd_data4(7:0)" />
            <blockpin signalname="XLXN_14(1:0)" name="in1(1:0)" />
            <blockpin signalname="XLXN_13(1:0)" name="in2(1:0)" />
            <blockpin signalname="da_clk" name="da_clk" />
            <blockpin signalname="XLXN_5(7:0)" name="rd_addr(7:0)" />
            <blockpin signalname="da_data(7:0)" name="da_data(7:0)" />
        </block>
        <block symbolname="rom" name="XLXI_5">
            <blockpin signalname="XLXN_5(7:0)" name="addra(7:0)" />
            <blockpin signalname="XLXN_6(7:0)" name="douta(7:0)" />
            <blockpin signalname="XLXN_23" name="clka" />
        </block>
        <block symbolname="rom_saw" name="XLXI_6">
            <blockpin signalname="XLXN_5(7:0)" name="addra(7:0)" />
            <blockpin signalname="XLXN_8(7:0)" name="douta(7:0)" />
            <blockpin signalname="XLXN_23" name="clka" />
        </block>
        <block symbolname="rom_squ" name="XLXI_7">
            <blockpin signalname="XLXN_5(7:0)" name="addra(7:0)" />
            <blockpin signalname="XLXN_9(7:0)" name="douta(7:0)" />
            <blockpin signalname="XLXN_23" name="clka" />
        </block>
        <block symbolname="rom_tri" name="XLXI_8">
            <blockpin signalname="XLXN_5(7:0)" name="addra(7:0)" />
            <blockpin signalname="XLXN_10(7:0)" name="douta(7:0)" />
            <blockpin signalname="XLXN_23" name="clka" />
        </block>
        <block symbolname="bufg" name="XLXI_9">
            <blockpin signalname="XLXN_23" name="I" />
            <blockpin signalname="XLXN_24" name="O" />
        </block>
        <block symbolname="ibufg" name="XLXI_11">
            <blockpin signalname="key1" name="I" />
            <blockpin signalname="XLXN_16" name="O" />
        </block>
        <block symbolname="ibufg" name="XLXI_12">
            <blockpin signalname="key2" name="I" />
            <blockpin signalname="XLXN_18" name="O" />
        </block>
        <block symbolname="ibufg" name="XLXI_13">
            <blockpin signalname="sys_clk" name="I" />
            <blockpin signalname="XLXN_23" name="O" />
        </block>
    </netlist>
    <sheet sheetnum="1" width="3520" height="2720">
        <instance x="1008" y="544" name="XLXI_1" orien="R0">
        </instance>
        <instance x="1008" y="720" name="XLXI_2" orien="R0">
        </instance>
        <instance x="1952" y="448" name="XLXI_3" orien="R0">
        </instance>
        <instance x="1952" y="1120" name="XLXI_4" orien="R0">
        </instance>
        <instance x="1008" y="864" name="XLXI_5" orien="R0">
        </instance>
        <instance x="992" y="1072" name="XLXI_6" orien="R0">
        </instance>
        <instance x="1008" y="1264" name="XLXI_7" orien="R0">
        </instance>
        <instance x="1008" y="1504" name="XLXI_8" orien="R0">
        </instance>
        <instance x="1584" y="320" name="XLXI_9" orien="R0" />
        <instance x="624" y="480" name="XLXI_11" orien="R0" />
        <instance x="624" y="656" name="XLXI_12" orien="R0" />
        <branch name="ad_clk">
            <wire x2="2576" y1="288" y2="288" x1="2336" />
        </branch>
        <branch name="ad_out(7:0)">
            <wire x2="2576" y1="416" y2="416" x1="2336" />
        </branch>
        <branch name="da_clk">
            <wire x2="2608" y1="640" y2="640" x1="2368" />
        </branch>
        <branch name="da_data(7:0)">
            <wire x2="2624" y1="1088" y2="1088" x1="2368" />
        </branch>
        <branch name="XLXN_5(7:0)">
            <wire x2="1008" y1="944" y2="944" x1="880" />
            <wire x2="880" y1="944" y2="1152" x1="880" />
            <wire x2="992" y1="1152" y2="1152" x1="880" />
            <wire x2="880" y1="1152" y2="1344" x1="880" />
            <wire x2="1008" y1="1344" y2="1344" x1="880" />
            <wire x2="880" y1="1344" y2="1584" x1="880" />
            <wire x2="880" y1="1584" y2="1920" x1="880" />
            <wire x2="2480" y1="1920" y2="1920" x1="880" />
            <wire x2="1008" y1="1584" y2="1584" x1="880" />
            <wire x2="2480" y1="864" y2="864" x1="2368" />
            <wire x2="2480" y1="864" y2="1920" x1="2480" />
        </branch>
        <branch name="XLXN_6(7:0)">
            <wire x2="1520" y1="928" y2="928" x1="1392" />
            <wire x2="1952" y1="768" y2="768" x1="1520" />
            <wire x2="1520" y1="768" y2="928" x1="1520" />
        </branch>
        <branch name="XLXN_8(7:0)">
            <wire x2="1520" y1="1136" y2="1136" x1="1408" />
            <wire x2="1728" y1="1136" y2="1136" x1="1520" />
            <wire x2="1728" y1="832" y2="1136" x1="1728" />
            <wire x2="1952" y1="832" y2="832" x1="1728" />
        </branch>
        <branch name="XLXN_9(7:0)">
            <wire x2="1520" y1="1328" y2="1328" x1="1408" />
            <wire x2="1744" y1="1328" y2="1328" x1="1520" />
            <wire x2="1744" y1="896" y2="1328" x1="1744" />
            <wire x2="1952" y1="896" y2="896" x1="1744" />
        </branch>
        <branch name="XLXN_10(7:0)">
            <wire x2="1600" y1="1568" y2="1568" x1="1408" />
            <wire x2="1952" y1="960" y2="960" x1="1600" />
            <wire x2="1600" y1="960" y2="1568" x1="1600" />
        </branch>
        <branch name="XLXN_13(1:0)">
            <wire x2="1440" y1="624" y2="624" x1="1392" />
            <wire x2="1440" y1="624" y2="1088" x1="1440" />
            <wire x2="1952" y1="1088" y2="1088" x1="1440" />
        </branch>
        <branch name="XLXN_14(1:0)">
            <wire x2="1584" y1="448" y2="448" x1="1392" />
            <wire x2="1584" y1="448" y2="1024" x1="1584" />
            <wire x2="1952" y1="1024" y2="1024" x1="1584" />
        </branch>
        <branch name="XLXN_16">
            <wire x2="1008" y1="448" y2="448" x1="848" />
        </branch>
        <branch name="key1">
            <wire x2="624" y1="448" y2="448" x1="368" />
        </branch>
        <branch name="XLXN_18">
            <wire x2="1008" y1="624" y2="624" x1="848" />
        </branch>
        <branch name="key2">
            <wire x2="624" y1="624" y2="624" x1="384" />
        </branch>
        <instance x="480" y="816" name="XLXI_13" orien="R0" />
        <branch name="sys_clk">
            <wire x2="480" y1="784" y2="784" x1="384" />
        </branch>
        <branch name="XLXN_23">
            <wire x2="784" y1="784" y2="784" x1="704" />
            <wire x2="800" y1="784" y2="784" x1="784" />
            <wire x2="800" y1="784" y2="992" x1="800" />
            <wire x2="1008" y1="992" y2="992" x1="800" />
            <wire x2="800" y1="992" y2="1200" x1="800" />
            <wire x2="992" y1="1200" y2="1200" x1="800" />
            <wire x2="800" y1="1200" y2="1408" x1="800" />
            <wire x2="800" y1="1408" y2="1664" x1="800" />
            <wire x2="1008" y1="1664" y2="1664" x1="800" />
            <wire x2="1008" y1="1408" y2="1408" x1="800" />
            <wire x2="1488" y1="784" y2="784" x1="800" />
            <wire x2="1584" y1="288" y2="288" x1="1488" />
            <wire x2="1488" y1="288" y2="640" x1="1488" />
            <wire x2="1488" y1="640" y2="784" x1="1488" />
            <wire x2="1952" y1="640" y2="640" x1="1488" />
        </branch>
        <branch name="XLXN_24">
            <wire x2="1952" y1="288" y2="288" x1="1808" />
        </branch>
        <branch name="sys_rst_n">
            <wire x2="896" y1="688" y2="688" x1="384" />
            <wire x2="1008" y1="688" y2="688" x1="896" />
            <wire x2="1008" y1="512" y2="512" x1="896" />
            <wire x2="896" y1="512" y2="560" x1="896" />
            <wire x2="896" y1="560" y2="688" x1="896" />
            <wire x2="1840" y1="560" y2="560" x1="896" />
            <wire x2="1840" y1="560" y2="704" x1="1840" />
            <wire x2="1952" y1="704" y2="704" x1="1840" />
            <wire x2="1952" y1="352" y2="352" x1="1840" />
            <wire x2="1840" y1="352" y2="560" x1="1840" />
        </branch>
        <branch name="ad_data(7:0)">
            <wire x2="1472" y1="240" y2="240" x1="352" />
            <wire x2="1472" y1="240" y2="416" x1="1472" />
            <wire x2="1952" y1="416" y2="416" x1="1472" />
        </branch>
        <iomarker fontsize="28" x="368" y="448" name="key1" orien="R180" />
        <iomarker fontsize="28" x="384" y="624" name="key2" orien="R180" />
        <iomarker fontsize="28" x="384" y="784" name="sys_clk" orien="R180" />
        <iomarker fontsize="28" x="384" y="688" name="sys_rst_n" orien="R180" />
        <iomarker fontsize="28" x="352" y="240" name="ad_data(7:0)" orien="R180" />
        <iomarker fontsize="28" x="2576" y="288" name="ad_clk" orien="R0" />
        <iomarker fontsize="28" x="2576" y="416" name="ad_out(7:0)" orien="R0" />
        <iomarker fontsize="28" x="2608" y="640" name="da_clk" orien="R0" />
        <iomarker fontsize="28" x="2624" y="1088" name="da_data(7:0)" orien="R0" />
    </sheet>
</drawing>