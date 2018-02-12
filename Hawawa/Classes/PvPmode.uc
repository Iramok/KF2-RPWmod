//2017.4.30 ����J�n
//2017.5.2 gan��kani���ƃe�X�g
//2017.5.27 �Ƃ��Ƃ����J�T�[�o�[�Ɂc
//2017.10.23 �Ȃ���Maxmonsters�̎d�l�ύX�ł������X�V�c�c

class PvPMode extends KFGameInfo_Survival;

//const
const	TRADERTIME = 75; //�g���[�_�[�̎���
const	WAVE1WAITTIME = 60; //�Q�[���J�n���̑ҋ@����
const	DOSHPERWAVE = 300; //10wave�ł̎����͂���10�{ �����wave���ɂ��䗦��������
const	CUSTOMGAMELENGTH = -1; //�J�X�^���Q�[���� 0�ȉ��Ȃ�f�t�H���g
const	ZEDTIMELENGTH = 3.0f; //ZED�^�C���̒���
const	MAXARMOR = 25; //�A�[�}�[�̍ő�l

const	CustomTimerLength_MyHUD  = 27.f; //�G�A�C�R����\���̎���
const	CustomTimerLength_TWIHUD = 3.f; //�G�A�C�R���\���̎���

var const float	TimerLength_MyHUD; //�G�A�C�R����\���̎���
var const float	TimerLength_TWIHUD; //�G�A�C�R���\���̎���

//pvpmain�p
var bool bOpend;
var int livingnum_old;

//Wave1NoDamage�p
var int CallCount;
var bool bForceNoDamage;

//�Q�[���J�n���Ɉ�x�����Ă΂����ۂ��`
event PostBeginPlay() {
	super.PostBeginPlay();
	//���傫��
		livingnum_old = 0;
	//�����܁[
		SetTimer(0.016, true, nameof(pvpmain));
	//�g���[�_�[�̎���
		TimeBetweenWaves = TRADERTIME;
	//�Q�[����
		if (CUSTOMGAMELENGTH>0) MyKFGRI.WaveMax = CUSTOMGAMELENGTH;
	//
}

//�A�[�}�[�̍ő�l��ύX
function SetArmorCustomVal() {
	local KFPawn_Human Player;
	local KFPlayerController KFPC;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		Player = KFPawn_Human(KFPC.Pawn);
		if (Player!=None) {
			Player.Armor = MAXARMOR;
			Player.MaxArmor = MAXARMOR;
		}
	}
}

/** Starts a new Wave */
function StartWave() {
	//���傫��
		super.StartWave();
	//zed���킩�Ȃ��悤�ɂ���
		ZeroMob();
	//�E�F�[�u1�J�n���͖��G�ɂ��A����ȊO�͖��G��؂�
		if (MyKFGRI.WaveNum==1) {
			CallCount = 0;
			bForceNoDamage = true;
			SetTimer(1.0,false,nameof(Wave1NoDamage));
		}
	//
}

//Wave1�J�n���̖��G
function Wave1NoDamage() {
	if (++CallCount==WAVE1WAITTIME) {
		SendMessageAllPlayers("PvP battle start !!!!!!");
		SetArmorCustomVal();
		bForceNoDamage = false;
	}else{
		SendMessageAllPlayers("PvP battle start in "$(WAVE1WAITTIME-CallCount)$"sec.");
		SetTimer(1.0,false,nameof(Wave1NoDamage));
	}
}

//�E�F�[�u���ɋ���z��
function GiveMoneyAllPlayers () {
	local KFPlayerController KFPC;
	local int DoshToGive;
	DoshToGive = DOSHPERWAVE*MyKFGRI.WaveNum*11/MyKFGRI.WaveMax;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh(-114514, true);
		KFPlayerReplicationInfo(KFPC.PlayerReplicationInfo).AddDosh(DoshToGive, true);
	}
}

//�S���Ƀ��b�Z�[�W�𑗂�
function SendMessageAllPlayers(string Str) {
	local KFPlayerController KFPC;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		SendMessagePlayer(KFPC,Str);
	}
}

//�l�Ƀ��b�Z�[�W�𑗂�
function SendMessagePlayer(KFPlayerController KFPC,string Str) {
	KFPC.TeamMessage(KFPC.PlayerReplicationInfo,Str,'Event');
}

//���G���
function GivePlayerMaxHealth() {
	local KFPawn_Human Player;
	local KFPlayerController KFPC;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		Player = KFPawn_Human(KFPC.Pawn);
		if (Player!=None) {
			Player.Health = Player.HealthMax;
			Player.Armor = Player.MaxArmor;
		}
	}
}

//���C�����[�v
function pvpmain(){
	local int livingnum;
	//�Q�[���͂��܂��Ƃ�񂪂�
		if (!(MyKFGRI.WaveNum>=1)) return;
	//���傫��
		livingnum = GetLivingPlayerCount();
	//����
		if (bForceNoDamage) GivePlayerMaxHealth();
		if (MyKFGRI.bTraderIsOpen) {
			//�J�X�Ɠ����ɋ���z��
			if (bOpend==false) GiveMoneyAllPlayers();
			GivePlayerMaxHealth();
		}else{
			//�X���� or �N��������
			if ( (bOpend==true) || (livingnum!=livingnum_old) ) {
				//zed�^�C��
					DramaticEvent(1.0,ZEDTIMELENGTH);
				//�����c���Ă�v���C���[�̐���\��
					SpawnManager.WaveTotalAI = livingnum;
					MyKFGRI.AIRemaining = livingnum;
					MyKFGRI.WaveTotalAICount = livingnum;
				//�A�[�}�[�̏���
					SetArmorCustomVal();
				//
			}
		}
	//�����ɂ�[
		bOpend = MyKFGRI.bTraderIsOpen;
		livingnum_old = livingnum;
	//
}

//zed�Ȃ�ĂȂ�����
function ZeroMob() {
	local int zeronum;
	zeronum = (MyKFGRI.WaveNum<MyKFGRI.WaveMax) ? 0 : 1;
//	zeronum = 0;
	
	//older
		/*
			SpawnManager.MaxMonstersSolo[int(GameDifficulty)] = zeronum;
			SpawnManager.MaxMonsters = zeronum;
		*/
	//newer v1056-
		SetMaxMonstersV1056(zeronum);
	//
}


//MM�̐ݒ� - KFmutator_MaxplayersV2���R�s�y v1056����Փx�E�l������MM���ł����悤��
function SetMaxMonstersV1056(byte mm_v1056) {
	local int i,j;
	for (i = 0; i < SpawnManager.PerDifficultyMaxMonsters.length; i++) {
		for (j = 0; j < SpawnManager.PerDifficultyMaxMonsters[i].MaxMonsters.length ; j++) {
			SpawnManager.PerDifficultyMaxMonsters[i].MaxMonsters[j] = mm_v1056;
		}
	}
}

//���S�������ɂ�΂��
function bool PreventDeath(Pawn Killed, Controller Killer, class<DamageType> damageType, vector HitLocation) {
	local bool bRet;
	if (Killed==None) return false;
	bRet = false;
	if(KFPawn_Human(Killed)!=None) {
		if (Killed.Controller.PlayerReplicationInfo.bIsSpectator==false) {
//			RestartPlayer(Killed.Controller);
			//�J�n1���ƃg���[�_�[���͎E���Ȃ�
			if ( (bForceNoDamage) || (MyKFGRI.bTraderIsOpen) ) {
				bRet = true;
			}else {
				if( GetLivingPlayerCount() <= 1 ) {
					if ( GetLivingPlayerCount() == 1 ) {
						SendMessageAllPlayers("Last stand player: "$Killer.PlayerReplicationInfo.PlayerName);
					}
					ScoreKill(Killer,Killed.Controller);
					if (MyKFGRI.WaveNum==MyKFGRI.WaveMax) {
						SendMessageAllPlayers("PvP Battle is end, GG!: ");
						//SendWinnerMessage();
					}else{
						//KFPlayerController(Killer).SpawnReconnectedPlayer();
					}
					WaveEnded(WEC_WaveWon);
					bRet=true;
				}
			}
		}
	}
//	if (bRet) 
	return bRet;
}

/*
function RespawnAllPlayer(KFPlayerController Killed) {
	local KFPlayerController KFPC;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		if (KFPC!=Killed) 
		KFPC.SpawnReconnectedPlayer();
	}
}
*/

DefaultProperties
{
	HUDType=class'PvPmode_KFHUD'
	TimerLength_MyHUD = CustomTimerLength_MyHUD
	TimerLength_TWIHUD = CustomTimerLength_TWIHUD
}

//�v���C���[�̃A�C�R����\��
/*
function ModifyPlayer(Pawn Other) {
	//�X�[�p�[�̏���
		super.ModifyPlayer(Other);
	//HUD�N���X�̒u������
		Other.Controller.ClientSetHUD();
	//
}
*/

/*
//�����҂�ʒm
function SendWinnerMessage() {
	local KFPlayerController KFPC;
	local int kill,Topkill;
	local string pName,TopkillerName;
	Topkill = -1;
	foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
		pName = KFPC.PlayerReplicationInfo.PlayerName;
		kill = KFPC.PlayerReplicationInfo.Kills;
		if ( Topkill < kill ) {
			TopkillerName = pName;
		}else if ( Topkill == kill ) {
			TopkillerName $= ","$pName;
		}
	}
	SendMessageAllPlayers("Top Killer: "$TopkillerName);
}
*/

//�i�j���V�i�C���c�Ǝv�������ǐ؂邩
/*
function DiscardInventory( Pawn Other, optional controller Killer ) {
}
*/


/**
function Killed(Controller Killer, Controller KilledPlayer, Pawn KilledPawn, class<DamageType> damageType) {
		super.Killed(Killer, KilledPlayer, KilledPawn, damageType);
	if (KilledPlayer!=None) {
		KilledPlayer.PlayerReplicationInfo.bIsSpectator = false;
		KilledPlayer.PlayerReplicationInfo.bIsSpectator = false;
		KilledPlayer.PlayerReplicationInfo.bOutOfLives = false;
		RestartPlayer(KilledPlayer);
	}else{
		super.Killed(Killer, KilledPlayer, KilledPawn, damageType);
	}
}

**/

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