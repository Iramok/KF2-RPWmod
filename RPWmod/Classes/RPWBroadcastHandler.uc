class RPWBroadcastHandler extends BroadcastHandler;

var RestrictPW MyRPW;

function InitRPWClass(RestrictPW NewRPW) {
	MyRPW = NewRPW;
}

function BroadcastText( PlayerReplicationInfo SenderPRI, PlayerController Receiver, coerce string Msg, optional name Type ) {
	if (MyRPW!=None) {
		if (SenderPRI!=None) {
			if (PlayerController(SenderPRI.Owner)==Receiver) {
				MyRPW.Broadcast(SenderPRI,Msg);
			}
		}
	}
	//����ȃ��b�Z�[�W�̓`���b�g�ɕ\�����Ȃ�
		if (MyRPW.StopBroadcast(Msg)) return;
	//�ʏ탁�b�Z�[�W���e�͕\�������
		super.BroadcastText(SenderPRI,Receiver,Msg,Type);
	//
}