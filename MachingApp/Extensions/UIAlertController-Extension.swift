//
//  UIAlertController-Extension.swift
//  MachingApp
//
//  Created by 田中　玲桐 on 2021/05/12.
//

import UIKit
import FirebaseFirestore


extension UIAlertController{
    
    static func createAlert(myuid:String,targetuid:String,name:String,complition:@escaping ()->Void)->UIAlertController{
        
        let alert=UIAlertController(title: "報告する", message:"\(name)さんには、知らされません.\n\n報告する理由を教えてください。\n\n\n\n\n\n", preferredStyle: .alert)
        
        let textView=UITextView()
        textView.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        textView.font = .systemFont(ofSize: 16)
        textView.layer.cornerRadius = 15
        
        let label=UILabel()
        label.backgroundColor = .red
        
                

        let confirmAction: UIAlertAction = UIAlertAction(title: "送信", style: UIAlertAction.Style.default, handler:{
            // ボタンが押された時の処理を書く（クロージャ実装）
            (action: UIAlertAction!) -> Void in
            guard let text=textView.text else {return}
            Firestore.AlertToFirestore(myuid: myuid, targetuid: targetuid, text: text){
                complition()
            }
        })
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            // キャンセルボタンが押された時の処理をクロージャ実装する
            (action: UIAlertAction!) -> Void in

        })
        alert.view.addSubview(textView)
        //UIAlertControllerにキャンセルボタンと確定ボタンをActionを追加
        alert.addAction(cancelAction)
        alert.addAction(confirmAction)

        textView.anchor(top:alert.view.topAnchor,bottom: alert.view.bottomAnchor,left:alert.view.leftAnchor,right: alert.view.rightAnchor,toppadding: 108,bottompadding: 46,leftpadding: 10,rightpadding: 10)
        
        alert.view.backgroundColor = .white
        alert.view.layer.cornerRadius = 15
        
        return alert
    }
    
    static func createreRegisterAlert()->UIAlertController{
        
        let alert: UIAlertController = UIAlertController(title: "利用規約", message: "\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n",
                                                         preferredStyle:  UIAlertController.Style.alert)
        
        let scrollView=UITextView()
        scrollView.backgroundColor = .clear
        scrollView.isEditable=false
        scrollView.isSelectable=false
        scrollView.font = .systemFont(ofSize: 16)
        scrollView.text = "この利用規約（以下，「本規約」といいます。）は，USPoN（以下，「当社」といいます。）がこのウェブサイト上で提供するサービス（以下，「本サービス」といいます。）の利用条件を定めるものです。登録ユーザーの皆さま（以下，「ユーザー」といいます。）には，本規約に従って，本サービスをご利用いただきます。\n\n第1条（適用）\n本規約は，ユーザーと当社との間の本サービスの利用に関わる一切の関係に適用されるものとします。当社は本サービスに関し，本規約のほか，ご利用にあたってのルール等，各種の定め（以下，「個別規定」といいます。）をすることがあります。これら個別規定はその名称のいかんに関わらず，本規約の一部を構成するものとします。本規約の規定が前条の個別規定の規定と矛盾する場合には，個別規定において特段の定めなき限り，個別規定の規定が優先されるものとします。\n\n第2条（利用登録）\n本サービスにおいては，登録希望者が本規約に同意の上，当社の定める方法によって利用登録を申請し，当社がこの承認を登録希望者に通知することによって，利用登録が完了するものとします。当社は，利用登録の申請者に以下の事由があると判断した場合，利用登録の申請を承認しないことがあり，その理由については一切の開示義務を負わないものとします。\n1.利用登録の申請に際して虚偽の事項を届け出た場合本規約に違反したことがある者からの申請である場合\n2.その他，当社が利用登録を相当でないと判断した場合\n\n第3条（ユーザーIDおよびパスワードの管理）\n1.ユーザーは，自己の責任において，本サービスのユーザーIDおよびパスワードを適切に管理するものとします。\n2.ユーザーは，いかなる場合にも，ユーザーIDおよびパスワードを第三者に譲渡または貸与し，もしくは第三者と共用することはできません。当社は，ユーザーIDとパスワードの組み合わせが登録情報と一致してログインされた場合には，そのユーザーIDを登録しているユーザー自身による利用とみなします。\n3.ユーザーID及びパスワードが第三者によって使用されたことによって生じた損害は，当社に故意又は重大な過失がある場合を除き，当社は一切の責任を負わないものとします。\n\n第4条（禁止事項)\nユーザーは，本サービスの利用にあたり，以下の行為をしてはなりません。\n法令または公序良俗に違反する行為\n犯罪行為に関連する行為\n当社，本サービスの他のユーザー，または第三者のサーバーまたはネットワークの機能を破壊したり，妨害したりする行為\n当社のサービスの運営を妨害するおそれのある行為\n他のユーザーに関する個人情報等を収集または蓄積する行為\n不正アクセスをし，またはこれを試みる行為\n他のユーザーに成りすます行為\n当社のサービスに関連して，反社会的勢力に対して直接または間接に利益を供与する行為\n当社，本サービスの他のユーザーまたは第三者の知的財産権，肖像権，プライバシー，名誉その他の権利または利益を侵害する行為\n以下の表現を含み，または含むと当社が判断する内容を本サービス上に投稿し，または送信する行為\n 過度に暴力的な表現\n 露骨な性的表現\n 人種，国籍，信条，性別，社会的身分，門地等による差別につながる表現\n 自殺，自傷行為，薬物乱用を誘引または助長する表現\n その他反社会的な内容を含み他人に不快感を与える表現\n 以下を目的とし，または目的とすると当社が判断する行為\n 営業，宣伝，広告，勧誘，その他営利を目的とする行為（当社の認めたものを除きます。）\n わいせつな行為を目的とする行為\n 他のユーザーに対する嫌がらせや誹謗中傷を目的とする行為\n当社，本サービスの他のユーザー，または第三者に不利益，損害または不快感を与えることを目的とする行為\n その他本サービスが予定している利用目的と異なる目的で本サービスを利用する行為\n 宗教活動または宗教団体への勧誘行為\n その他，当社が不適切と判断する行為\n\n第5条（本サービスの提供の停止等）\n・当社は，以下のいずれかの事由があると判断した場合，ユーザーに事前に通知することなく本サービスの全部または一部の提供を停止または中断することができるものとします。\n 1.本サービスにかかるコンピュータシステムの保守点検または更新を行う場合\n 2.地震，落雷，火災，停電または天災などの不可抗力により，本サービスの提供が困難となった場合\n 3.コンピュータまたは通信回線等が事故により停止した場合\n 4.その他，当社が本サービスの提供が困難と判断した場合\n・当社は，本サービスの提供の停止または中断により，ユーザーまたは第三者が被ったいかなる不利益または損害についても，一切の責任を負わないものとします\n\n第6条（著作権）\n・ユーザーは，自ら著作権等の必要な知的財産権を有するか，または必要な権利者の許諾を得た文章，画像や映像等の情報に関してのみ，本サービスを利用し，投稿ないしアップロードすることができるものとします。\n・ユーザーが本サービスを利用して投稿ないしアップロードした文章，画像，映像等の著作権については，当該ユーザーその他既存の権利者に留保されるものとします。ただし，当社は，本サービスを利用して投稿ないしアップロードされた文章，画像，映像等について，本サービスの改良，品質の向上，または不備の是正等ならびに本サービスの周知宣伝等に必要な範囲で利用できるものとし，ユーザーは，この利用に関して，著作者人格権を行使しないものとします。\n・前項本文の定めるものを除き，本サービスおよび本サービスに関連する一切の情報についての著作権およびその他の知的財産権はすべて当社または当社にその利用を許諾した権利者に帰属し，ユーザーは無断で複製，譲渡，貸与，翻訳，改変，転載，公衆送信（送信可能化を含みます。），伝送，配布，出版，営業使用等をしてはならないものとします。\n\n第7条（利用制限および登録抹消）\n・当社は，ユーザーが以下のいずれかに該当する場合には，事前の通知なく，投稿データを削除し，ユーザーに対して本サービスの全部もしくは一部の利用を制限しまたはユーザーとしての登録を抹消することができるものとします。\n 1.本規約のいずれかの条項に違反した場合\n 2.登録事項に虚偽の事実があることが判明した場合\n 3.当社からの連絡に対し，一定期間返答がない場合\n 4.本サービスについて，最終の利用から一定期間利用がない場合\n 5.その他，当社が本サービスの利用を適当でないと判断した場合/n・前項各号のいずれかに該当した場合，ユーザーは，当然に当社に対する一切の債務について期限の利益を失い，その時点において負担する一切の債務を直ちに一括して弁済しなければなりません。\n ・当社は，本条に基づき当社が行った行為によりユーザーに生じた損害について，一切の責任を負いません。\n\n第8条（退会）\nユーザーは，当社の定める退会手続により，本サービスから退会できるものとします。\n\n第9条（保証の否認および免責事項）\n・当社は，本サービスに事実上または法律上の瑕疵（安全性，信頼性，正確性，完全性，有効性，特定の目的への適合性，セキュリティなどに関する欠陥，エラーやバグ，権利侵害などを含みます。）がないことを明示的にも黙示的にも保証しておりません。\n・当社は，本サービスに関して，ユーザーと他のユーザーまたは第三者との間において生じた取引，連絡または紛争等について一切責任を負いません。\n\n第10条（サービス内容の変更等）\n当社は，ユーザーに通知することなく，本サービスの内容を変更しまたは本サービスの提供を中止することができるものとし，これによってユーザーに生じた損害について一切の責任を負いません。\n\n第11条（利用規約の変更）\n当社は，必要と判断した場合には，ユーザーに通知することなくいつでも本規約を変更することができるものとします。なお，本規約の変更後，本サービスの利用を開始した場合には，当該ユーザーは変更後の規約に同意したものとみなします。\n\n第12条（個人情報の取扱い）\n当社は，本サービスの利用によって取得する個人情報については，当社「プライバシーポリシー」に従い適切に取り扱うものとします。\n\n第13条（通知または連絡）\n ユーザーと当社との間の通知または連絡は，当社の定める方法によって行うものとします。当社は,ユーザーから,当社が別途定める方式に従った変更届け出がない限り,現在登録されている連絡先が有効なものとみなして当該連絡先へ通知または連絡を行い,これらは,発信時にユーザーへ到達したものとみなします。\n\n第14条（権利義務の譲渡の禁止）\nユーザーは，当社の書面による事前の承諾なく，利用契約上の地位または本規約に基づく権利もしくは義務を第三者に譲渡し，または担保に供することはできません。"
        alert.view.addSubview(scrollView)
    
        let defaultAction: UIAlertAction = UIAlertAction(title: "同意する", style: UIAlertAction.Style.default, handler:{
                // ボタンが押された時の処理を書く（クロージャ実装）
                (action: UIAlertAction!) -> Void in
            })

            // ③ UIAlertControllerにActionを追加
            alert.addAction(defaultAction)
        
        scrollView.anchor(top: alert.view.topAnchor,bottom: alert.view.bottomAnchor,left: alert.view.leftAnchor,right: alert.view.rightAnchor,toppadding: 50, bottompadding: 45)
        
        return alert
    }
}
