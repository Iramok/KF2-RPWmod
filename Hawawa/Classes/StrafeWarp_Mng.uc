//�}�l�[�W���[
//�����ɕ�����l���������Ă���

class StrafeWarp_Mng extends KFmutator;

var NavigationPoint CurrentPlayerStartPoint;
var byte Warp_UseNumRemain;

//3�l(33%)�A2�l(66%)���킯��
function byte GetNextWarpUseNum() {
	return (Rand(3)==0) ? 3 : 2;
}

//�X�^�[�g�n�_�̎擾
function NavigationPoint GetStartPoint(KFPlayerController KFPC) {
	//�X�^�[�g�n�_�̍X�V
		if (Warp_UseNumRemain<=0) ResetStartPoint(KFPC);
	//�񐔂̏���
		Warp_UseNumRemain --;
	//
	return CurrentPlayerStartPoint;
}

//�X�^�[�g�n�_�̏�����
function ResetStartPoint(KFPlayerController KFPC) {
	CurrentPlayerStartPoint = ChoosePlayerStart(KFPC);
	Warp_UseNumRemain = GetNextWarpUseNum();
}

//�V�����n�_�̎擾
function PlayerStart ChoosePlayerStart( Controller Player, optional byte InTeam )
{
	local PlayerStart P, BestStart;
	local int navinum,selid,i;

//	local byte Team;
	// use InTeam if player doesn't have a team yet
//	Team = ( (Player != None) && (Player.PlayerReplicationInfo != None) && (Player.PlayerReplicationInfo.Team != None) )
//			? byte(Player.PlayerReplicationInfo.Team.TeamIndex)
//			: InTeam;
	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P) {
		navinum ++;
	}
	if (navinum==0) return None;
	selid = Rand(navinum);
	i = 0;
	// Find best playerstart
	foreach WorldInfo.AllNavigationPoints(class'PlayerStart', P) {
		if ( i++ == selid ) {
			BestStart = P;
			break;
		}
	}
	return BestStart;
}