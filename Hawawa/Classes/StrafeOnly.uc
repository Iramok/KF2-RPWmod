//2017.4.16 ����J�n
//4.17 �֎~�p�[�N�̔���A�E�F�[�u���̔���͂ł���(�E�ցE)
//4.18 �֎~���킪����̂ŃJ�j������������
//4.19 ��������
//4.30 RGplay�ɓ������Ă݂���
//
//6.13 �C�x���g�Ɍ����ă��[�v�����Ă݂�
//

//***STATE***
//strafe �I����
//�V���K�~���̂݉��ړ��̂ݓ��͎󂯂�
//�ړ����x�̓_�b�V���̑��x���炢�ɂ�����

//���p������N���X��Mutator�łȂ������ǂ�
//  Mutator�ɂł����Ƃ��Ă�����GameInfo���������Ă���̂�
//  ��������\���������A�����������Ă���̂��킩��Â炢

class StrafeOnly extends KFGameInfo_Survival;

var bool bOpend;
var StrafeWarp SW;

//�Q�[���J�n���Ɉ�x�����Ă΂����ۂ��`
event PostBeginPlay() {
	super.PostBeginPlay();
	//������
		SW = Spawn(class'StrafeWarp');
		SW.Init();
		bOpend = true;
		SetTimer(0.5, true, nameof(pvpmain));
	//
}

//���C�����[�v
function pvpmain(){
	//�Q�[���͂��܂��Ƃ�񂪂�
		if (!(MyKFGRI.WaveNum>=1)) return;
	//�X����
		if ( (!MyKFGRI.bTraderIsOpen) && (bOpend==true) ) {
			WarpAllPC();
		}
	//�����ɂ�[
		bOpend = MyKFGRI.bTraderIsOpen;
	//
}

//�����_���n�_��PC���΂�
function WarpAllPC() {
	local KFPlayerController KFPC;
	local bool bInit;
	bInit = false;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		//�Ō�̃��[�v����g���܂킳�Ȃ�
			if (bInit==false) {
				SW.ResetStartPoint(KFPC);
				bInit = true;
			}
		//
		SW.WarpPC(KFPC);
	}
}

defaultproperties
{
	PlayerControllerClass=class'StrafeOnly_KFPC'
	DefaultPawnClass=class'StrafeOnly_KFPH'
}


//�ȉ��ʕ�


	/**
	//�Q�[���J�n���Ɉ�x�����Ă΂��H
	function PostBeginPlay() {
		//1.0�b���Ƃɓ���̊֐����Ă� bool�l�͌J��Ԃ��ĂԂ��ǂ���
		SetTimer(1.0, true, nameof(SetPlayersKaniWalk));
	}
	//�v���C���[���J�j������v@_@v
	function SetPlayersKaniWalk() {
		local KFPlayerController KFPC;
		local Pawn Player;
	//			MoveForwardSpeed
		//�g���[�_�[�^�C�����ƏI���㉽�b���ɑ��x���X�V
		if (false) {
			return;
		}
		foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
			if (KFPC.Pawn != None) {
				Player = KFPC.Pawn;
				if (KFPC.InputClass==class'KFPlayerInput2') {
	//				Player.Health = 21;
				}else{
	//				Player.Health = 35;
					KFPC.InputClass = class'KFPlayerInput2';
				}
			}
		}
	}
	*/