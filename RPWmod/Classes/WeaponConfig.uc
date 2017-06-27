//2017.5.23 �������ۂ��` �Ƃ肠�����_���[�W�Ǝˌ����x��������
//�����F
//Type_PenetrationPower��KFWeapon.uc��GetInitialPenetrationPower�֐��ɉe���ł��Ȃ��̂Ŕp��
//5.24 �T�[�o�[��łȂ���rate�������Ȃ��̂Ń_���[�W�����ɂȂ��Ă��܂����c
//
//�ǉ����ׂ����́F���R�C���H


//NetDamage in Mutator.uc����_���[�W��ς����

//class WeaponConfig within RestrictPW
class WeaponConfig extends Object within RestrictPW
	config(RestrictPW);

/*
WeaponConfig=AssaultRifle_AK12::Pen_Def=1.0,Rate_Alt=1.5,Dmg_Hvy=3.0
P1
	(DT=Class'KFGameContent.KFDT_Ballistic_M4Shotgun',Multiplier=1.400000,DebugName="M4 Combat Shotgun")
*/

//<<---config�p�ϐ��̒�`--->>//
	var config bool bUseWeaponConfig;
	var config array<string> WeaponConfig;

//<<---global�ϐ��̒�`--->>//
	//���ς���Ώ� Type_Null�͐����������񂪏�����Ă��Ȃ��ꍇ�̑Ώ�
		enum ModifyType {
			Type_Null,
			Type_InstantHitDamage,
//			Type_FireInterval
//			Type_PenetrationPower
		};
	//���[�h�Ɣ{���̎w��
		struct ModifyData {
			var ModifyType MType;
			var byte FireMode;
			var float Multiplier;
		};
	//config���璊�o�����f�[�^
		struct WeaponData {
			var string WeaponName;
			var array<ModifyData> MData;
		};
	//config�֘A
		var array<WeaponData> WD;
	//�K�p���ꂽ����̊Ǘ�
		var array<KFWeapon> ModifiedWeap;
		var int ModifyCount;
	//ModifiedWeap��length�������Ȃ肷���Ȃ��悤�ɒ���(Find�֐��Ɏ��Ԃ������肻��)
		const ReModifyCountNum = 24; //8Player��3��ނ̕�����g���z��
	
//<<---���ʗp������̒�`--->>//

	const MTCode_InstantHitDamage	= "Dmg";
//	const MTCode_FireInterval		= "Rate";
//	const MTCode_PenetrationPower	= "Pen";
	
	const FMCode_Default	= "Def";
	const FMCode_AltFire	= "Alt";
	const FMCode_Bash		= "Bash";
	const FMCode_HeavyAtk	= "Hvy";
	
//<<---FireMode�̒�`--->>//
	
	const NULL_FIREMODE				= -1; //Null FireMode for my mod
	const DEFAULT_FIREMODE			= 0; //Def+C4
	const ALTFIRE_FIREMODE			= 1;
	const BASH_FIREMODE				= 3;
	const HEAVY_ATK_FIREMODE		= 5; // for melee weapons

//for test
	
	function ShowTestMessage(string s) {
		Outer.SendRestrictMessageStringAll(s);
		/*
		local KFPlayerController KFPC;
		foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
			KFPC.TeamMessage(KFPC.PlayerReplicationInfo,s,'Event');
		}
		*/
	}

//<<---�������֐�--->>//

	function InitConfigVar() {
		WeaponConfig.AddItem("");	//1�s�����T���v���Ƃ��Ēǉ�
		bUseWeaponConfig = false;
	}

//<<---�������֐�(ReadConfigString)--->>//
	
	//WeaponConfig��z��Ƃ��ēǂݍ���
	function ReadConfigString(){
		local string buf;
		buf = ""; //�x���΍�
		foreach WeaponConfig(buf) {
			WD.AddItem(GetWeaponDataFromString(buf));
		}
	}
	
	//WeaponConfig��1�s���ǂݍ���
	//WeaponConfig=AssaultRifle_AK12::Pen_Def=1.0,Rate_Alt=1.5,Dmg_Hvy=3.0
	function WeaponData GetWeaponDataFromString(string WDStr) {
		local WeaponData WDret;
		local string MDBuf;
		local array<string> SplitBuf,ModData;
		local class<Weapon> cWbuf;
		//�ǂݍ��ݎ��s�p�̏�����
			WDret.WeaponName = "";
		//����
			ParseStringIntoArray(WDStr,SplitBuf,"::",true);
			if (SplitBuf.length!=2) return WDret;
		//���O�̏���
			cWbuf = Outer.GetWeapClassFromString("KFGameContent.KFWeap_"$SplitBuf[0]);
			if (cWbuf==None) return WDret;
			WDret.WeaponName = cWbuf.default.ItemName;
//ShowTestMessage("touroku::"$WDret.WeaponName);
		//Modify�̏���
			ParseStringIntoArray(SplitBuf[1],ModData,",",true);
			foreach ModData(MDBuf) {
				WDret.MData.AddItem(GetModifyDataFromString(MDBuf));
//ShowTestMessage("FMode:"$WDret.MData[WDret.MData.length-1].FireMode$" MType:"$WDret.MData[WDret.MData.length-1].MType$" Muti:"$WDret.MData[WDret.MData.length-1].Multiplier);
			}
		//�����̏I��
			return WDret;
		//
	}
	
	//�eWeaponConfig��ModifyData���o���������̂���f�[�^���擾
	//Pen_Def=1.0 Rate_Alt=1.5 Dmg_Hvy=3.0
	function ModifyData GetModifyDataFromString(string MDStr) {
		local ModifyData MDret;
		local array<string> SplitBuf1,SplitBuf2;
		//�ǂݍ��ݎ��s�p�̏�����
			MDret.MType = Type_Null;
		//����
			ParseStringIntoArray(MDStr,SplitBuf1,"_",true);
			if (SplitBuf1.length!=2) return MDret;
			ParseStringIntoArray(SplitBuf1[1],SplitBuf2,"=",true);
			if (SplitBuf2.length!=2) return MDret;
		//FireMode�̐ݒ� **���s���̕Ԃ�l��Type_Null��K���Ԃ��ׂ�**
			MDret.FireMode = GetFireModeFromString(SplitBuf2[0]);
			if (MDret.FireMode==NULL_FIREMODE) return MDret; //MDret.ModifyType must be Type_Null; 
		//ModifyType�̐ݒ�
			MDret.MType = GetModifyTypeFromString(SplitBuf1[0]);
			if (MDret.MType==Type_Null) return MDret; //Type_Null�̂��߂��̌�̏����͕K�v�Ȃ�
		//Multiplier�̐ݒ� ���s�̊��m�͕s�\�Ȃ̂�float�֐��ɂ܂�����
			MDret.Multiplier = float(SplitBuf2[1]);
		//
		return MDret;
	}
	
	//���̂�����ۂ�ModifyType�̔ԍ����擾
	function ModifyType GetModifyTypeFromString(string MTStr){
		switch(MTStr) {
			case MTCode_InstantHitDamage:
				return Type_InstantHitDamage;
/*
			case MTCode_FireInterval:
				return Type_FireInterval;
			case MTCode_PenetrationPower:
				return Type_PenetrationPower;
*/
		}
		return Type_Null;
	}
	
	//���̂�����ۂ�FireMode�̔ԍ����擾
	function byte GetFireModeFromString(string FMStr){
		switch(FMStr) {
			case FMCode_Default:
				return DEFAULT_FIREMODE;
			case FMCode_AltFire:
				return ALTFIRE_FIREMODE;
			case FMCode_Bash:
				return BASH_FIREMODE;
			case FMCode_HeavyAtk:
				return HEAVY_ATK_FIREMODE;
		}
		return NULL_FIREMODE;
	}

//<<---�R�[���o�b�N�֐�(PostBeginPlay)--->>//

	function PostBeginPlay() {
//		Super.PostBeginPlay();
		//.ini�̏����ݒ�
			if (!Outer.bIWontInitThisConfig) InitConfigVar();
//		Hogeeeeeee.AddItem("bbb");
			SaveConfig();
		//config�l���΂炷
			ReadConfigString();
		//
	}
	
	event Tick() {
		local KFPlayerController KFPC;
		local KFWeapon Weap;
		//�E�F�[�u���J�n����Ă��Ȃ��ꍇ�͂ǂ��ł�����
			if (!(MyKFGI.MyKFGRI.WaveNum>=1)) return;
		//�S�v���C���[�ɂ��āA���ݑ������Ă��镐��̒l������
			foreach WorldInfo.AllControllers(class'KFPlayerController', KFPC) {
				if (KFPC.Pawn==None) continue;
				Weap = KFWeapon(KFPC.Pawn.Weapon);
				if ( (Weap!=None) && (ModifiedWeap.Find(Weap)==-1) ) {
//				if(true) {
//ReadConfigString();
					//����̒l����
						ModifyWeapon(Weap);
					//modify���ꂽ����̔z��Ǘ�
						ModifiedWeap.Add(1);
						ModifiedWeap[ModifiedWeap.length-1] = Weap;
						if ( ModifyCount++ >= ReModifyCountNum ) {
							ModifiedWeap.Remove(0,ModifiedWeap.length);
							ModifyCount = 0;
						}
					//
				}
			}
		//
	}
	
	//����̒l����������
	function ModifyWeapon(KFWeapon Weap) {
		local ModifyData MDBuf;
		local int Index;
		Index = WD.Find('WeaponName',Weap.ItemName);
		if (Index==-1) return;
//ShowTestMessage("SetItemNameIs"$Weap.ItemName);
		foreach WD[Index].MData(MDBuf){
			ApplyModifyData(Weap,MDbuf);
		}
	}
	
	//���ۂɕ���ɒl��K�p����
	function ApplyModifyData(KFWeapon Weap,ModifyData MD){
		//���FInstantHitDamage,FireInterval,PenetrationPower�͂��ׂ�array<Float>�Ȃ̂ł��̂܂܊|���Z�\
		switch(MD.MType) {
			case Type_Null:
				return; //do nothing in case of Type_Null
			case Type_InstantHitDamage:
				Weap.InstantHitDamage[MD.FireMode]	= MD.Multiplier * Weap.Class.default.InstantHitDamage[MD.FireMode];
				//����Ұ�ނ�1�ȏ�Ȃ�A�_���[�W�̉�����1�ɂ���
				if (Weap.Class.default.InstantHitDamage[MD.FireMode]>0) {
					Weap.InstantHitDamage[MD.FireMode]	= max ( 1, Weap.InstantHitDamage[MD.FireMode] );
				}
//ShowTestMessage("Dmg::"$Weap.InstantHitDamage[MD.FireMode]);
				break;
/*
			case Type_FireInterval:
				Weap.FireInterval[MD.FireMode]		= MD.Multiplier * Weap.Class.default.FireInterval[MD.FireMode];
//ShowTestMessage("Rate::"$Weap.FireInterval[MD.FireMode]);
LogInternal("Rate::"$Weap.FireInterval[MD.FireMode]);
			break;
			case Type_PenetrationPower:
				Weap.PenetrationPower[MD.FireMode]	= MD.Multiplier * Weap.Class.default.PenetrationPower[MD.FireMode];
ShowTestMessage("Pen::"$Weap.PenetrationPower[MD.FireMode]);
				break;
*/
		}
		return;
	}
	

//

/*

		//KFWeapon.uc
			
			Weap.InstantHitDamage[ALTFIRE_FIREMODE]=400.0;
			FireInterval(DEFAULT_FIREMODE)=+1.0
			PenetrationPower(DEFAULT_FIREMODE)=0.0
			AmmoCost(DEFAULT_FIREMODE)=1

			//KFWeap_HealerBase
				HealSelfRechargeSeconds=15
				HealOtherRechargeSeconds=7.5

		//���f�B�b�N�Ɋւ��Ă�
			//KFWeap_MedicBase
			    HealAmount=15
				HealFullRechargeSeconds=10
		//�g���[�_�[�Ɋւ�鍀�ڂ�NG
			//KFWeapon.uc
				InventorySize=6
				GroupPriority=75
				InitialSpareMags[0]	= 2
				MagazineCapacity[0]	= 30
				SpareAmmoCapacity[0]= 210
				InitialSpareMags[1]	= 3
				MagazineCapacity[1]	= 1
				SpareAmmoCapacity[1]= 11
		//�V���b�g�K���̒e����7�Œ�H�ł�����
			//KFWeap_ShotgunBase
				//NumPellets(DEFAULT_FIREMODE)=7

*/