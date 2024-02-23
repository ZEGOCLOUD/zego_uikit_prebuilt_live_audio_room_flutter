// Project imports:
import 'package:zego_uikit_prebuilt_live_audio_room/src/defines.dart';

/// Control the text on the UI.
/// Modify the values of the corresponding properties to modify the text on the UI.
/// You can also change it to other languages.
/// This class is used for the ZegoUIKitPrebuiltLiveAudioRoomConfig.innerText property.
/// **Note that the placeholder %0 in the text will be replaced with the corresponding username.**
class ZegoUIKitPrebuiltLiveAudioRoomInnerText {
  /// %0: is a string placeholder, represents the first parameter of prompt

  final String param_1 = '%0';

  /// The button displayed in the popup menu when the audience clicks to request take a seat .
  /// The **default value** is *"Take the seat"*.
  String takeSeatMenuButton;

  /// The button displayed in the popup menu when the host clicks on the "speaker" on a seat to move the speaker down.
  /// The **default value** is *"Remove %0 from seat"*, where %0 will be replaced with the corresponding username.
  String removeSpeakerMenuDialogButton;

  /// The button displayed in the popup menu when the host clicks on the "speaker" on a seat to mute the speaker.
  /// The **default value** is *"Mute %0"*, where %0 will be replaced with the corresponding username.
  String muteSpeakerMenuDialogButton;

  /// The cancel button in the popup menu.
  /// The **default value** is *"Cancel"*.
  String cancelMenuDialogButton;

  /// The text of button which host kick out audience or speakers from the live audio room.
  /// The **default value** is *"Remove %0 from the room"*, where %0 will be replaced with the corresponding username.
  String removeUserMenuDialogButton;

  /// The title of the member list,
  /// The **default value** is *"Audience"*.
  String memberListTitle;

  /// The label for displaying yourself in the member list.
  /// The **default value** is *"You"*.
  String memberListRoleYou;

  /// The label for displaying the host in the member list.
  /// The **default value** is *"Host"*.
  String memberListRoleHost;

  /// The label for displaying speakers in the member list.
  /// The **default value** is *"Speaker"*.
  String memberListRoleSpeaker;

  /// The toast message displayed when the host fails to move a speaker down from a seat.
  /// The **default value** is *"Failed to remove %0 from seat"*, where %0 will be replaced with the corresponding username.
  String removeSpeakerFailedToast;

  /// The placeholder text displayed in the chat input box when there is no content.
  /// The **default value** is *"Say something..."*.
  String messageEmptyToast;

  /// The dialog for camera permission settings.
  /// The **default values** are:
  /// - Title: "Can not use Camera!"
  /// - Message: "Please enable camera access in the system settings!"
  /// - Cancel button name: "Cancel"
  /// - Confirm button name: "Settings"
  ZegoLiveAudioRoomDialogInfo cameraPermissionSettingDialogInfo;

  /// The dialog for microphone permission settings.
  /// The **default values** are:
  /// - Title: "Can not use Microphone!"
  /// - Message: "Please enable microphone access in the system settings!"
  /// - Cancel button name: "Cancel"
  /// - Confirm button name: "Settings"
  ZegoLiveAudioRoomDialogInfo microphonePermissionSettingDialogInfo;

  /// The confirmation dialog displayed before the host moves a speaker down from a seat.
  /// The **default values** are:
  /// - Title: "Remove the speaker"
  /// - Message: "Are you sure to remove %0 from the seat?", where %0 will be replaced with the corresponding username.
  /// - Cancel button name: "Cancel"
  /// - Confirm button name: "OK"
  ZegoLiveAudioRoomDialogInfo removeFromSeatDialogInfo;

  /// The confirmation dialog displayed before a speaker voluntarily leaves a seat.
  /// The **default values** are:
  /// - Title: "Leave the seat"
  /// - Message: "Are you sure to leave seat?"
  /// - Cancel button name: "Cancel"
  /// - Confirm button name: "OK"
  ZegoLiveAudioRoomDialogInfo leaveSeatDialogInfo;

  /// The button for audience members to apply for taking a seat during the live session.
  /// The **default value** is *"Apply to take seat"*.
  String applyToTakeSeatButton;

  /// The button for audience members to cancel their application for taking a seat during the live session.
  /// The **default value** is *"Cancel"*.
  String cancelTheTakeSeatApplicationButton;

  /// The button on the member list to accept an audience member's seat application.
  /// The **default value** is *"Agree"*.
  String memberListAgreeButton;

  /// The button on the member list to reject an audience member's seat application.
  /// The **default value** is *"Disagree"*.
  String memberListDisagreeButton;

  /// The button displayed when the host clicks the "More" button on the member list to invite an audience member to take a seat.
  /// The **default value** is *"Invite %0 to take seat"*, where %0 will be replaced with the corresponding username.
  String inviteToTakeSeatMenuDialogButton;

  /// The invitation dialog displayed to the audience member after being invited by the host to take a seat.
  /// The **default values** are:
  /// - Title: "Invitation"
  /// - Message: "The host is inviting you to take seat"
  /// - Cancel button name: "Disagree"
  /// - Confirm button name: "Agree"
  ZegoLiveAudioRoomDialogInfo hostInviteTakeSeatDialog;

  /// The button displayed in the popup menu when the host clicks on the "speaker" on a seat to assign the speaker as a co-host.
  /// The **default value** is *"Assign %0 as Co-Host"*, where %0 will be replaced with the corresponding username.
  String assignAsCoHostMenuDialogButton;

  /// The button displayed in the popup menu when the host clicks on the "speaker" on a seat to revoke the speaker's co-host privileges.
  /// The **default value** is *"Revoke %0's Co-Host Privileges"*, where %0 will be replaced with the corresponding username.
  String revokeCoHostPrivilegesMenuDialogButton;

  /// The title of the audio effects dialog.
  /// The **default value** is *"Audio effects"*.
  String audioEffectTitle;

  /// The title of the reverb category.
  /// The **default value** is *"Reverb"*.
  String audioEffectReverbTitle;

  /// The title of the voice changing category.
  /// The **default value** is *"Voice changing"*.
  String audioEffectVoiceChangingTitle;

  /// Voice changing effect: None
  String voiceChangerNoneTitle;

  /// Voice changing effect: Little Boy
  String voiceChangerLittleBoyTitle;

  /// Voice changing effect: Little Girl
  String voiceChangerLittleGirlTitle;

  /// Voice changing effect: Deep
  String voiceChangerDeepTitle;

  /// Voice changing effect: Crystal-clear
  String voiceChangerCrystalClearTitle;

  /// Voice changing effect: Robot
  String voiceChangerRobotTitle;

  /// Voice changing effect: Ethereal
  String voiceChangerEtherealTitle;

  /// Voice changing effect：Female
  String voiceChangerFemaleTitle;

  /// Voice changing effect：Male
  String voiceChangerMaleTitle;

  /// Voice changing effect：Optimus Prime
  String voiceChangerOptimusPrimeTitle;

  /// Voice changing effect：C Major
  String voiceChangerCMajorTitle;

  /// Voice changing effect：A Major
  String voiceChangerAMajorTitle;

  /// Voice changing effect：Harmonic minor
  String voiceChangerHarmonicMinorTitle;

  /// Reverb effect：None
  String reverbTypeNoneTitle;

  /// Reverb effect: Karaoke
  String reverbTypeKTVTitle;

  /// Reverb effect：Hall
  String reverbTypeHallTitle;

  /// Reverb effect：Concert
  String reverbTypeConcertTitle;

  /// Reverb effect：Rock
  String reverbTypeRockTitle;

  /// Reverb effect：Small room
  String reverbTypeSmallRoomTitle;

  /// Reverb effect：Large room
  String reverbTypeLargeRoomTitle;

  /// Reverb effect：Valley
  String reverbTypeValleyTitle;

  /// Reverb effect：Recording studio
  String reverbTypeRecordingStudioTitle;

  /// Reverb effect：Basement
  String reverbTypeBasementTitle;

  /// Reverb effect：Pop
  String reverbTypePopularTitle;

  /// Reverb effect：Gramophone
  String reverbTypeGramophoneTitle;

  ZegoUIKitPrebuiltLiveAudioRoomInnerText({
    String? takeSeatMenuButton,
    String? removeSpeakerMenuDialogButton,
    String? muteSpeakerMenuDialogButton,
    String? cancelMenuDialogButton,
    String? removeUserMenuDialogButton,
    String? memberListTitle,
    String? memberListRoleYou,
    String? memberListRoleHost,
    String? memberListRoleSpeaker,
    String? removeSpeakerFailedToast,
    String? messageEmptyToast,
    String? applyToTakeSeatButton,
    String? cancelTheTakeSeatApplicationButton,
    String? memberListAgreeButton,
    String? memberListDisagreeButton,
    String? inviteToTakeSeatMenuDialogButton,
    String? assignAsCoHostMenuDialogButton,
    String? revokeCoHostPrivilegesMenuDialogButton,
    ZegoLiveAudioRoomDialogInfo? cameraPermissionSettingDialogInfo,
    ZegoLiveAudioRoomDialogInfo? microphonePermissionSettingDialogInfo,
    ZegoLiveAudioRoomDialogInfo? removeFromSeatDialogInfo,
    ZegoLiveAudioRoomDialogInfo? leaveSeatDialogInfo,
    ZegoLiveAudioRoomDialogInfo? hostInviteTakeSeatDialog,
    String? audioEffectTitle,
    String? audioEffectReverbTitle,
    String? audioEffectVoiceChangingTitle,
    String? voiceChangerNoneTitle,
    String? voiceChangerLittleBoyTitle,
    String? voiceChangerLittleGirlTitle,
    String? voiceChangerDeepTitle,
    String? voiceChangerCrystalClearTitle,
    String? voiceChangerRobotTitle,
    String? voiceChangerEtherealTitle,
    String? voiceChangerFemaleTitle,
    String? voiceChangerMaleTitle,
    String? voiceChangerOptimusPrimeTitle,
    String? voiceChangerCMajorTitle,
    String? voiceChangerAMajorTitle,
    String? voiceChangerHarmonicMinorTitle,
    String? reverbTypeNoneTitle,
    String? reverbTypeKTVTitle,
    String? reverbTypeHallTitle,
    String? reverbTypeConcertTitle,
    String? reverbTypeRockTitle,
    String? reverbTypeSmallRoomTitle,
    String? reverbTypeLargeRoomTitle,
    String? reverbTypeValleyTitle,
    String? reverbTypeRecordingStudioTitle,
    String? reverbTypeBasementTitle,
    String? reverbTypePopularTitle,
    String? reverbTypeGramophoneTitle,
  })  : takeSeatMenuButton = takeSeatMenuButton ?? 'Take the seat',
        removeSpeakerMenuDialogButton =
            removeSpeakerMenuDialogButton ?? 'Remove %0 from seat',
        muteSpeakerMenuDialogButton = muteSpeakerMenuDialogButton ?? 'Mute %0',
        cancelMenuDialogButton = cancelMenuDialogButton ?? 'Cancel',
        removeUserMenuDialogButton =
            removeUserMenuDialogButton ?? 'Remove %0 from the room',
        memberListTitle = memberListTitle ?? 'Audience',
        memberListRoleYou = memberListRoleYou ?? 'You',
        memberListRoleHost = memberListRoleHost ?? 'Host',
        memberListRoleSpeaker = memberListRoleSpeaker ?? 'Speaker',
        removeSpeakerFailedToast =
            removeSpeakerFailedToast ?? 'Failed to remove %0 from seat',
        messageEmptyToast = messageEmptyToast ?? 'Say something...',
        applyToTakeSeatButton = applyToTakeSeatButton ?? 'Apply to take seat',
        cancelTheTakeSeatApplicationButton =
            cancelTheTakeSeatApplicationButton ?? 'Cancel',
        memberListAgreeButton = memberListAgreeButton ?? 'Agree',
        memberListDisagreeButton = memberListDisagreeButton ?? 'Disagree',
        inviteToTakeSeatMenuDialogButton =
            inviteToTakeSeatMenuDialogButton ?? 'Invite %0 to take seat',
        assignAsCoHostMenuDialogButton =
            assignAsCoHostMenuDialogButton ?? 'Assign %0 as Co-Host',
        revokeCoHostPrivilegesMenuDialogButton =
            revokeCoHostPrivilegesMenuDialogButton ??
                "Revoke %0's Co-Host Privileges",
        cameraPermissionSettingDialogInfo = cameraPermissionSettingDialogInfo ??
            ZegoLiveAudioRoomDialogInfo(
              title: 'Can not use Camera!',
              message: 'Please enable camera access in the system settings!',
              cancelButtonName: 'Cancel',
              confirmButtonName: 'Settings',
            ),
        microphonePermissionSettingDialogInfo =
            microphonePermissionSettingDialogInfo ??
                ZegoLiveAudioRoomDialogInfo(
                  title: 'Can not use Microphone!',
                  message:
                      'Please enable microphone access in the system settings!',
                  cancelButtonName: 'Cancel',
                  confirmButtonName: 'Settings',
                ),
        removeFromSeatDialogInfo = removeFromSeatDialogInfo ??
            ZegoLiveAudioRoomDialogInfo(
              title: 'Remove the speaker',
              message: 'Are you sure to remove %0 from the seat?',
              cancelButtonName: 'Cancel',
              confirmButtonName: 'OK',
            ),
        leaveSeatDialogInfo = leaveSeatDialogInfo ??
            ZegoLiveAudioRoomDialogInfo(
              title: 'Leave the seat',
              message: 'Are you sure to leave seat?',
              cancelButtonName: 'Cancel',
              confirmButtonName: 'OK',
            ),
        hostInviteTakeSeatDialog = hostInviteTakeSeatDialog ??
            ZegoLiveAudioRoomDialogInfo(
              title: 'Invitation',
              message: 'The host is inviting you to take seat',
              cancelButtonName: 'Disagree',
              confirmButtonName: 'Agree',
            ),
        audioEffectTitle = audioEffectTitle ?? 'Audio effects',
        audioEffectReverbTitle = audioEffectReverbTitle ?? 'Reverb',
        audioEffectVoiceChangingTitle =
            audioEffectVoiceChangingTitle ?? 'Voice changing',
        voiceChangerNoneTitle = voiceChangerNoneTitle ?? 'None',
        voiceChangerLittleBoyTitle = voiceChangerLittleBoyTitle ?? 'Little boy',
        voiceChangerLittleGirlTitle =
            voiceChangerLittleGirlTitle ?? 'Little girl',
        voiceChangerDeepTitle = voiceChangerDeepTitle ?? 'Deep',
        voiceChangerCrystalClearTitle =
            voiceChangerCrystalClearTitle ?? 'Crystal-clear',
        voiceChangerRobotTitle = voiceChangerRobotTitle ?? 'Robot',
        voiceChangerEtherealTitle = voiceChangerEtherealTitle ?? 'Ethereal',
        voiceChangerFemaleTitle = voiceChangerFemaleTitle ?? 'Female',
        voiceChangerMaleTitle = voiceChangerMaleTitle ?? 'Male',
        voiceChangerOptimusPrimeTitle =
            voiceChangerOptimusPrimeTitle ?? 'Optimus Prime',
        voiceChangerCMajorTitle = voiceChangerCMajorTitle ?? 'C major',
        voiceChangerAMajorTitle = voiceChangerAMajorTitle ?? 'A major',
        voiceChangerHarmonicMinorTitle =
            voiceChangerHarmonicMinorTitle ?? 'Harmonic minor',
        reverbTypeNoneTitle = reverbTypeNoneTitle ?? 'None',
        reverbTypeKTVTitle = reverbTypeKTVTitle ?? 'Karaoke',
        reverbTypeHallTitle = reverbTypeHallTitle ?? 'Hall',
        reverbTypeConcertTitle = reverbTypeConcertTitle ?? 'Concert',
        reverbTypeRockTitle = reverbTypeRockTitle ?? 'Rock',
        reverbTypeSmallRoomTitle = reverbTypeSmallRoomTitle ?? 'Small room',
        reverbTypeLargeRoomTitle = reverbTypeLargeRoomTitle ?? 'Large room',
        reverbTypeValleyTitle = reverbTypeValleyTitle ?? 'Valley',
        reverbTypeRecordingStudioTitle =
            reverbTypeRecordingStudioTitle ?? 'Recording studio',
        reverbTypeBasementTitle = reverbTypeBasementTitle ?? 'Basement',
        reverbTypePopularTitle = reverbTypePopularTitle ?? 'Pop',
        reverbTypeGramophoneTitle = reverbTypeGramophoneTitle ?? 'Gramophone';
}
