//
//  CreateMessage.swift
//  App
//
//  Created by Alex Young on 5/18/20.
//

import Foundation
#if canImport(FoundationNetworking)
import FoundationNetworking
#endif


final class ActiveCampaign {
/*
    func messageHTML() -> String {
        
        let htmlText = """
        <!doctype html>
        <html>
        <head>
        <meta charset="UTF-8">
        <title>emailTest</title>
        </head>
        <body>
            
        <!-- OPENING -->
            
        <div id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754ac-designer" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754body" style="font-family:Arial;line-height:1.1;margin:0px;background-color:#ffffff;width:100%;text-align:center">
        <div class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754divbody" style="margin:0px;outline:none;padding:0px;color:#000000;font-family:arial;line-height:1.1;width:100%;background-color:#ffffff;background:#ffffff;text-align:center">
        <table class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754template-table" border="0" cellpadding="0" cellspacing="0" width="100%" align="left" style="font-size:13px;min-width:auto;background-color:#ffffff;background:#ffffff;float: none">
        <tbody>
        <tr>
        <td align="center" valign="top" width="100%">
        <table class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754template-table" border="0" cellpadding="0" cellspacing="0" width="600" bgcolor="#ffffff" style="font-size:13px;min-width:auto;max-width:600px">
        <tbody>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout_table_ceb5cdf64ab4fab54b10f0af40ac96fe10f52061" valign="top" align="center" width="600">
        <table cellpadding="0" cellspacing="0" border="0" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-table m_5640241793615494444m_-8244975343849878056m_3744579026415683754root-table" width="600" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-margin1531" valign="top">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row1531" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row m_5640241793615494444m_-8244975343849878056m_3744579026415683754widget m_5640241793615494444m_-8244975343849878056m_3744579026415683754_widget_picture" align="center">
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-padding1531" valign="top">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754image-td" align="center" valign="top" width="600"><img src="http://buddhavipassana.ca/wp-content/uploads/2017/08/BuddhavipassanaLogo.jpg" alt="" width="75" style="display:block;border:none;outline:none;width:75px;opacity:1;max-width:100%" class="CToWUd"></td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-margin1528" valign="top" style="padding:10px 0px 20px 0px">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%;border-collapse:initial!important">
        <tbody>
        <tr id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row1528" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row m_5640241793615494444m_-8244975343849878056m_3744579026415683754widget m_5640241793615494444m_-8244975343849878056m_3744579026415683754_widget_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754style1528" style="margin:0;padding:0">
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-padding1528" valign="top" style="padding:0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754text_div1502" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_block" valign="top" align="left" style="color:inherit;font-size:inherit;font-weight:inherit;line-height:1;text-decoration:inherit;font-family:Arial">
        <div style="margin:0;outline:none;padding:0;color:#555555">
        <div style="margin:0;outline:none;padding:0;color:#555555">
        <div style="margin:0;outline:none;padding:0;text-align:center;color:#555555"><span style="color:#555555;font-size:inherit;font-weight:inherit;line-height:inherit;text-decoration:inherit;font-family:verdana,arial,sans"><span style="color:#555555;font-size:16px;font-weight:bold;line-height:inherit;text-decoration:inherit"> BUDDHAVIPASSANA</span>
        <br style="color:#555555"><span style="color:#555555;font-size:10px;font-weight:inherit;line-height:inherit;text-decoration:inherit">MEDITATION CENTRE | TORONTO</span></span>
        </div>
        </div>
        </div>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-margin1529" valign="top" style="padding:0px">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%;border-collapse:initial!important">
        <tbody>
        <tr id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row1529" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row m_5640241793615494444m_-8244975343849878056m_3744579026415683754widget m_5640241793615494444m_-8244975343849878056m_3744579026415683754_widget_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754style1529" style="margin:0;padding:0;background-color:#bababa">
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-padding1529" valign="top" style="background-color:#bababa;padding:10px 10px 15px 10px">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754text_div1503" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_block" valign="top" align="left" style="color:inherit;font-size:inherit;font-weight:inherit;line-height:1;text-decoration:inherit;font-family:Arial">
        <div style="margin:0;outline:none;padding:0;font-size:13px">
        <div style="margin:0;outline:none;padding:0;color:#555555">
        <div style="margin:0;outline:none;padding:0;color:#555555">
        <div style="margin:0;outline:none;padding:0;color:#555555">
        <div style="margin:0;outline:none;padding:0;text-align:center;color:#555555">
        <div style="margin:0;outline:none;padding:0;font-family:arial"><span style="color:#555555;font-size:inherit;font-weight:inherit;line-height:inherit;text-decoration:inherit">The Buddhavipassana Meditation Centre remains closed during the COVID-19 Emergency Period. The centre will re-open based on guidance from the Government of Ontario.</span></div>
        <div style="margin:0;outline:none;padding:0;font-family:arial"></div>
        </div>
        </div>
        </div>
        </div>
        </div>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        <!--CONTENT -->
            
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-margin1530" valign="top" style="padding:0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%;border-collapse:initial!important">
        <tbody>
        <tr id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row1530" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row m_5640241793615494444m_-8244975343849878056m_3744579026415683754widget m_5640241793615494444m_-8244975343849878056m_3744579026415683754_widget_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754style1530" style="margin:0;padding:0;background-color:#bababa">
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-padding1530" valign="top" style="background-color:#bababa;padding:0 0 5px 0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754text_div1504" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_block" valign="top" align="left" style="color:inherit;font-size:inherit;font-weight:inherit;line-height:1;text-decoration:inherit;font-family:Arial">
        <div style="margin:0;outline:none;padding:0">
        <br>
        </div>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-margin1534" valign="top" style="padding:15px 0 10px 0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%;border-collapse:initial!important">
        <tbody>
        <tr id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row1534" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row m_5640241793615494444m_-8244975343849878056m_3744579026415683754widget m_5640241793615494444m_-8244975343849878056m_3744579026415683754_widget_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754style1534" style="margin:0;padding:0">
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-padding1534" valign="top" style="padding:0 9px 0px 10px">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754text_div1508" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_block" valign="top" align="left" style="color:inherit;font-size:inherit;font-weight:inherit;line-height:1;text-decoration:inherit;font-family:Arial">
        <div style="margin:0;outline:none;padding:0;font-size:16px">
        <div style="margin:0;outline:none;padding:0"> <span style="color:inherit;font-size:inherit;font-weight:inherit;line-height:inherit;text-decoration:inherit;font-family:verdana,arial,sans">%FIRSTNAME% –<p>                <p>As we progress in life, success will inevitably lead to greater rewards but also greater responsibility. Stress resulting from having too many things to do is a sign of progress rather than a cause for concern. However, new challenges require us to also acquire new skills to deal with our additional workload. When we are overwhelmed with work, the only way to solve the problem is to establish clear priorities.</p> <p>Ironically, our first priority needs to be the process of setting priorities itself. Perhaps that feels like a waste of time but nothing could be further from the truth. The simple reality is that the benefit we gain from efficient activity is exponentially greater than the benefit we gain from other less productive uses of our time. The most effective way to accomplish priority setting is through spiritual practice. This is so because when we engage in introspection, we are essentially determining what outcomes are most important to us in life. There is no better use of our time because, by reflecting on our priorities, we can eliminate most of the wasteful busy work and focus on those actions that actually result in satisfaction.</p> <p>The process of introspection that the Buddha laid down for us is surprisingly simple. In order to understand what we should do next, we need to bring the mind to what we are doing now. This process is called mindfulness because we fill the mind with the present moment. Another way to describe mindfulness is to call it insight meditation because by bringing the mind into the present moment, we gain insight into the true nature of reality as we experience it from moment to moment. This in turn results in enhanced clarity about how we can become satisfied.</p> <p>In summary then, we should not become discouraged when we feel overwhelmed. We should instead use this feeling to guide us towards an even greater destination. That destination which we are all capable of reaching is one where our minds are no longer trapped in worries about the future or lamenting the past but rather firmly established and rejoicing in the present moment.</p></p>Sincerely,<br><br><br>Alex Young</span></div>
        </div>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-margin1532" valign="top" style="padding:0">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%;border-collapse:initial!important">
        <tbody>
        <tr id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row1532" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row m_5640241793615494444m_-8244975343849878056m_3744579026415683754widget m_5640241793615494444m_-8244975343849878056m_3744579026415683754_widget_rss m_5640241793615494444m_-8244975343849878056m_3744579026415683754style1532">
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-padding1532" valign="top" style="padding:0px 10px 0px 10px">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_rss m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_block" valign="top" align="left" style="font-family:Arial" width="580">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size:13px;min-width:100%;font-family:arial,sans">
        <tbody>
        <tr style="font-family:arial,sans">
        <td style="vertical-align:top;font-family:arial,sans">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size:13px;min-width:100%;font-family:arial,sans">
        <tbody>
        <tr style="font-family:arial,sans">
        <td class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754rss-item-padding m_5640241793615494444m_-8244975343849878056m_3744579026415683754rss-image-padding m_5640241793615494444m_-8244975343849878056m_3744579026415683754rss-item-atom_content" style="vertical-align:top;font-family:arial,sans;padding:5px 0px 5px 0px;max-width:580px">
        <table cellpadding="0" cellspacing="0" border="0" width="100%" style="font-size:13px;min-width:100%;font-family:arial,sans">
        <tbody>
        <tr style="font-family:arial,sans">
        <td class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754rss-item m_5640241793615494444m_-8244975343849878056m_3744579026415683754rss-text m_5640241793615494444m_-8244975343849878056m_3744579026415683754rss-item-atom_content" style="vertical-align:top;font-family:verdana,arial,sans;font-size:16px;">
            
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-margin1527" valign="top">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row1527" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row m_5640241793615494444m_-8244975343849878056m_3744579026415683754widget m_5640241793615494444m_-8244975343849878056m_3744579026415683754_widget_text" style="margin:0;padding:0">
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754layout-row-padding1527" valign="top">
        <table width="100%" border="0" cellpadding="0" cellspacing="0" style="font-size:13px;min-width:100%">
        <tbody>
        <tr>
        <td id="m_5640241793615494444m_-8244975343849878056m_3744579026415683754text_div1501" class="m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_text m_5640241793615494444m_-8244975343849878056m_3744579026415683754td_block" valign="top" align="left" style="color:inherit;font-size:inherit;font-weight:inherit;line-height:1;text-decoration:inherit;font-family:Arial">
        <div style="margin:0;outline:none;padding:0"> <span style="color:inherit;font-size:inherit;font-weight:inherit;line-height:inherit;text-decoration:inherit"> <span style="color:inherit;font-size:11px;font-weight:inherit;line-height:inherit;text-decoration:inherit"> </span></span>
        <div style="margin:0;outline:none;padding:0;text-align:center"><span style="color:#555555;font-size:12px;font-weight:inherit;line-height:inherit;text-decoration:inherit">
        <!--
        // Sent to:&nbsp;
        // <a href="mailto:' . $username .'" target="_blank">' . $username . '</a></span></div>
        -->
        Sent to: %EMAIL%
        <div style="margin:0;outline:none;padding:0;text-align:center"><span style="color:#555555;font-size:12px;font-weight:inherit;line-height:inherit;text-decoration:inherit">
        <!--// Buddhavipassana Meditation Centre, 46 Tyrrel Avenue, Toronto, Ontario M6G 2G2, Canada> -->
        %SENDER-INFO-SINGLELINE%</span></div><div style="margin:0;outline:none;padding:0;text-align:center"><span style="color:#555555;font-size:12px;font-weight:inherit;line-height:inherit;text-decoration:inherit"><div style="margin:0;outline:none;padding:0;display:inline">Don't want future emails?</div>
         <!-- // <a href="http://buddhavipassana.acemlna.com/proc.php?nl=3&amp;c=89&amp;m=105&amp;s=bb731ad6eaa9ea99aee38254461f5260&amp;act=unsub" style="margin:0;outline:none;padding:0;color:#555555;text-decoration:underline" target="_blank" data-saferedirecturl="https://www.google.com/url?hl=uk&amp;q=http://buddhavipassana.acemlna.com/proc.php?nl%3D3%26c%3D89%26m%3D105%26s%3Dbb731ad6eaa9ea99aee38254461f5260%26act%3Dunsub&amp;source=gmail&amp;ust=1500995749172000&amp;usg=AFQjCNF0-vQQ9cABjvU6WKu41n7r9Vy6yQ">
        <span style="color:#555555;font-size:inherit;font-weight:inherit;line-height:inherit;text-decoration:inherit">Unsubscribe</span></a> -->
        <a href="%UNSUBSCRIBELINK%">Unsubscribe</a>
         </span>
        <br style="text-align:inherit;color:#333333">
        </div>
        </div>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </td>
        </tr>
        </tbody>
        </table>
        </div>
        </body>
        </html>
        """
        return htmlText
    }
*/
    func createMessage(using: String) -> String {
        let url = "https://buddhavipassana.api-us1.com/admin/api.php"

        let parameters = [
            "api_action":"message_add",
            "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
            "api_output": "json"
        ]

        
        
        let postData = [
            "fromemail":"alex.young@buddhavipassana.ca",
            "format" : "html",
            "reply2" : "alex.young@buddhavipassana.ca",
            "priority" : "3",
            "encoding" : "quoted-printable",
            "textfetch" : "http://yoursite.com",
            "subject" : "Test Subject",
            "textfetchwhen": "send",
            "p[9]":"9",
            "html": using
        ]

        let endpoint = Api(url: url, parameters: parameters, postData: postData)
        let apiRequest = endpoint.request()
        let apiResponse = endpoint.responseString(using: apiRequest)
        print (apiResponse)
        
        
        // decode the JSON response to get the message ID
        
        struct ApiData: Codable {
            var id : String
        }
        
        let jsonData = apiResponse.data(using: .utf8)!
        let decoder = JSONDecoder()
        let apiData = try! decoder.decode(ApiData.self, from: jsonData)
        print ("Message ID is \(apiData.id)")
        return (apiData.id)
    }


    func createCampaign(messageID: String, messageName: String, sdate: String) {

        let url = "https://buddhavipassana.api-us1.com/admin/api.php"

        let parameters = [
            "api_action":"campaign_create",
            "api_key": "2daf12468b84cb1a82f928d3ec3ee4694df15eecd57d4fd8059dae454e179c6cf1287934",
            "api_output": "json"
        ]

        let postData = [
            "type":"single",
            "name" : messageName,
            "sdate" : sdate,
            "status" : "1",
            "public" : "1",
            "p[9]" : "9",
            "m[\(messageID)]" : "100"
        ]

        let endpoint = Api(url: url, parameters: parameters, postData: postData)
        let apiRequest = endpoint.request()
        let apiResponse = endpoint.responseString(using: apiRequest)
        print (apiResponse)

    }
    
    
}
