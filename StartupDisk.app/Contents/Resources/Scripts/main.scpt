FasdUAS 1.101.10   ��   ��    k             l     ��  ��      Startup Disk     � 	 	    S t a r t u p   D i s k   
  
 l     ��  ��    [ U This AppleScript App is copyright 2020-2012 by Todd Bruss | StarPlayrX | NiceMac LLC     �   �   T h i s   A p p l e S c r i p t   A p p   i s   c o p y r i g h t   2 0 2 0 - 2 0 1 2   b y   T o d d   B r u s s   |   S t a r P l a y r X   |   N i c e M a c   L L C      l     ��  ��      Donationware App     �   "   D o n a t i o n w a r e   A p p      l     ��  ��    C = https://www.paypal.com/donate?hosted_button_id=M3U48FLF87SXQ     �   z   h t t p s : / / w w w . p a y p a l . c o m / d o n a t e ? h o s t e d _ b u t t o n _ i d = M 3 U 4 8 F L F 8 7 S X Q      l     ��  ��    ) #defaults if you don't want to enter     �   F d e f a u l t s   i f   y o u   d o n ' t   w a n t   t o   e n t e r      l     ��   !��     < 6there is a security risk if you don't save as run only    ! � " " l t h e r e   i s   a   s e c u r i t y   r i s k   i f   y o u   d o n ' t   s a v e   a s   r u n   o n l y   # $ # l     ��������  ��  ��   $  % & % l     �� ' (��   ' � �Why was this created? Since Big Sur came along Unsupported and eve Supported users under Catalina can't select a Mac OS 11.x disk anymore.    ( � ) ) W h y   w a s   t h i s   c r e a t e d ?   S i n c e   B i g   S u r   c a m e   a l o n g   U n s u p p o r t e d   a n d   e v e   S u p p o r t e d   u s e r s   u n d e r   C a t a l i n a   c a n ' t   s e l e c t   a   M a c   O S   1 1 . x   d i s k   a n y m o r e . &  * + * l     �� , -��   , . ( I have not tested this under Mojave Yet    - � . . P   I   h a v e   n o t   t e s t e d   t h i s   u n d e r   M o j a v e   Y e t +  / 0 / l     �� 1 2��   1 , & Please donate if you find this useful    2 � 3 3 L   P l e a s e   d o n a t e   i f   y o u   f i n d   t h i s   u s e f u l 0  4 5 4 l     ��������  ��  ��   5  6 7 6 j     �� 8�� 0 
versiontag 
versionTag 8 m      9 9 � : : �<�T   b i g m a c   v 1 . 1 7  ; < ; l     ��������  ��  ��   <  = > = j    �� ?�� 0 user   ? m     @ @ � A A   >  B C B j    �� D�� 0 pass   D m     E E � F F   C  G H G l     ��������  ��  ��   H  I J I l     K L M K r      N O N m     ��
�� boovtrue O o      ���� 0 	disklabel 	diskLabel L I C determines if the text of the disk label should be set to its name    M � P P �   d e t e r m i n e s   i f   t h e   t e x t   o f   t h e   d i s k   l a b e l   s h o u l d   b e   s e t   t o   i t s   n a m e J  Q R Q l    S T U S r     V W V m    ��
�� boovfals W o      ���� 0 
fastreboot 
fastReboot T ( " when on will reboot in an instant    U � X X D   w h e n   o n   w i l l   r e b o o t   i n   a n   i n s t a n t R  Y Z Y l    [ \ ] [ r     ^ _ ^ m    	��
�� boovfals _ o      ���� 0 usemountonly useMountOnly \ e _ Uses all that is required to select a startup disk, if false, it will try to set the efi stuff    ] � ` ` �   U s e s   a l l   t h a t   i s   r e q u i r e d   t o   s e l e c t   a   s t a r t u p   d i s k ,   i f   f a l s e ,   i t   w i l l   t r y   t o   s e t   t h e   e f i   s t u f f Z  a b a l     ��������  ��  ��   b  c d c j   	 �� e�� 0 startupdisk startupDisk e m   	 
 f f � g g   d  h i h l      j k l j j    �� m�� 0 donation   m m     n n � o o x h t t p s : / / w w w . p a y p a l . c o m / d o n a t e ? h o s t e d _ b u t t o n _ i d = M 3 U 4 8 F L F 8 7 S X Q k . ( Do not edit this line, we will find you    l � p p P   D o   n o t   e d i t   t h i s   l i n e ,   w e   w i l l   f i n d   y o u i  q r q l      s t u s j    �� v�� 0 	bigmacurl 	bigmacURL v m     w w � x x H h t t p s : / / g i t h u b . c o m / S t a r P l a y r X / b i g m a c t   Do not edit    u � y y    D o   n o t   e d i t r  z { z l    |���� | r     } ~ } m       � � � * S t a r t u p   D i s k   C h o o s e r   ~ o      ���� (0 startupdiskchooser startupDiskChooser��  ��   {  � � � l    ����� � r     � � � m     � � � � � ( B y   S t a r P l a y r X   � � 2 0 2 1 � o      ���� 0 	copyright  ��  ��   �  � � � l    ����� � r     � � � m     � � � � �  D o n a t e � o      ���� 0 	donatebtn 	donateBtn��  ��   �  � � � l    ����� � r     � � � m     � � � � � * S e l e c t   A   S t a r t u p   D i s k � o      ���� 0 selectdiskbtn selectDiskBtn��  ��   �  � � � l    ����� � r     � � � m     � � � � �  Q u i t � o      ���� 0 quitbtn quitBtn��  ��   �  � � � l    # ����� � r     # � � � m     ! � � � � �  G i t h u b � o      ���� 0 	githubbtn 	gitHubBtn��  ��   �  � � � l  $ ) ����� � r   $ ) � � � m   $ % � � � � �  F a s t   R e b o o t � o      ���� 0 fastrebootbtn fastRebootBtn��  ��   �  � � � l  * 1 ����� � r   * 1 � � � m   * - � � � � �  R e b o o t � o      ���� 0 	rebootbtn 	rebootBtn��  ��   �  � � � l     ��������  ��  ��   �  � � � l  2 g ����� � r   2 g � � � I  2 c�� � �
�� .sysodlogaskr        TEXT � b   2 G � � � b   2 A � � � b   2 = � � � b   2 9 � � � m   2 5 � � � � � 0�=ݥ   S t a r t u p   D i s k   C h o o s e r   � o   5 8��
�� 
ret  � m   9 < � � � � � X�=�v   b y   T o d d   B r u s s ,   N i c e M a c   L L C   � � 2 0 2 0   -   2 0 2 1   � o   = @��
�� 
ret  � o   A F���� 0 
versiontag 
versionTag � �� � �
�� 
btns � J   J O � �  � � � o   J K���� 0 selectdiskbtn selectDiskBtn �  � � � o   K L���� 0 	githubbtn 	gitHubBtn �  ��� � o   L M���� 0 quitbtn quitBtn��   � �� � �
�� 
dflt � m   R S����  � �� � �
�� 
disp � m   V W����  � �� ���
�� 
appr � m   Z ] � � � � � & S t a r P l a y r X   P r e s e n t s��   � o      ���� 0 
buttonsrtn 
buttonsRtn��  ��   �  � � � l     ��������  ��  ��   �  � � � l  h ����� � Z   h � � ��� � =  h q � � � n   h o � � � 1   k o��
�� 
bhit � o   h k���� 0 
buttonsrtn 
buttonsRtn � o   o p���� 0 	githubbtn 	gitHubBtn � I  t }�� ���
�� .GURLGURLnull��� ��� TEXT � o   t y���� 0 	bigmacurl 	bigmacURL��   �  � � � =  � � � � � n   � � � � � 1   � ���
�� 
bhit � o   � ����� 0 
buttonsrtn 
buttonsRtn � o   � ����� 0 quitbtn quitBtn �  � � � I  � �������
�� .aevtquitnull��� ��� null��  ��   �  � � � =  � � � � � n   � � � � � 1   � ���
�� 
bhit � o   � ����� 0 
buttonsrtn 
buttonsRtn � m   � � � � � � � * S e l e c t   A   S t a r t u p   D i s k �  � � � k   �� � �  � � � l  � ���������  ��  ��   �  � � � r   � � � � � e   � � � � I  � ��� � �
�� .earsffdralis        afdr �  f   � � � �� ���
�� 
rtyp � m   � ���
�� 
TEXT��   � o      ���� 0 pp   �    r   � � b   � � o   � ����� 0 pp   m   � � � 0 C o n t e n t s : R e s o u r c e s : b l e s s o      ���� 	0 bless   	 r   � �

 b   � � o   � ����� 0 pp   m   � � � & C o n t e n t s : R e s o u r c e s : o      ���� 0 	resources  	  l  � ���������  ��  ��    r   � � n   � � 1   � ���
�� 
psxp o   � ����� 0 	resources   o      ���� 0 	resources    r   � � n   � � 1   � ���
�� 
psxp o   � ����� 	0 bless   o      ���� 	0 bless    l  � ���������  ��  ��    !  l  � ���"#��  " A ; try to get the startup disk -- This is not 100% full proof   # �$$ v   t r y   t o   g e t   t h e   s t a r t u p   d i s k   - -   T h i s   i s   n o t   1 0 0 %   f u l l   p r o o f! %&% l  � �����~��  �  �~  & '(' Q   �)*+) k   �v,, -.- l  � ��}/0�}  / + % you must fille out the top correctly   0 �11 J   y o u   m u s t   f i l l e   o u t   t h e   t o p   c o r r e c t l y. 232 Z   �@45�|64 F   � �787 >  � �9:9 o   � ��{�{ 0 user  : m   � �;; �<<  8 >  � �=>= o   � ��z�z 0 pass  > m   � �?? �@@  5 r  *ABA I &�yCD
�y .sysoexecTEXT���     TEXTC b  EFE b  GHG m  II �JJ  s u d o   'H o  �x�x 0 	resources  F m  KK �LL  s y s t e m d i s k s . s h 'D �wMN
�w 
RAunM o  �v�v 0 user  N �uOP
�u 
RApwO o  �t�t 0 pass  P �sQ�r
�s 
badmQ m   �q
�q boovtrue�r  B o      �p�p  0 getsystemdisks getSystemDisks�|  6 r  -@RSR I -<�oTU
�o .sysoexecTEXT���     TEXTT b  -4VWV o  -0�n�n 0 	resources  W m  03XX �YY  s y s t e m d i s k s . s hU �mZ�l
�m 
badmZ m  78�k
�k boovtrue�l  S o      �j�j  0 getsystemdisks getSystemDisks3 [\[ l AA�i�h�g�i  �h  �g  \ ]^] r  AL_`_ n  AHaba 2 DH�f
�f 
cparb o  AD�e�e  0 getsystemdisks getSystemDisks` o      �d�d  0 getsystemdisks getSystemDisks^ cdc r  M\efe I MX�cg�b
�c .sysoexecTEXT���     TEXTg b  MThih o  MP�a�a 	0 bless  i m  PSjj �kk    - - g e t b o o t�b  f o      �`�` 0 devdisk devDiskd lml l ]]�_�^�]�_  �^  �]  m non l ]]�\pq�\  p  Get disk name   q �rr  G e t   d i s k   n a m eo s�[s r  ]vtut I ]p�Zvw
�Z .sysoexecTEXT���     TEXTv b  ]hxyx b  ]dz{z m  ]`|| �}} � / S y s t e m / L i b r a r y / F i l e s y s t e m s / a p f s . f s / C o n t e n t s / R e s o u r c e s / a p f s . u t i l   - p  { o  `c�Y�Y 0 devdisk devDisky m  dg~~ �    &w �X��W
�X 
badm� m  kl�V
�V boovtrue�W  u o      �U�U 0 startupdisk startupDisk�[  * R      �T��S
�T .ascrerr ****      � ****� o      �R�R 0 errmsg errMsg�S  + k  ~�� ��� l ~~�Q�P�O�Q  �P  �O  � ��� Z  ~����N�M� E  ~���� o  ~�L�L 0 errmsg errMsg� m  ��� ���  C a n c e l� I ���K�J�I
�K .aevtquitnull��� ��� null�J  �I  �N  �M  � ��� l ���H�G�F�H  �G  �F  � ��� Z  ����E�� G  ����� G  ����� G  ����� E  ����� o  ���D�D 0 errmsg errMsg� m  ���� ��� > C a n ' t   i n t e r p r e t   E F I   b o o t   d e v i c e� E  ����� o  ���C�C 0 errmsg errMsg� m  ���� ��� 2 N o   s u c h   f i l e   o r   d i r e c t o r y� E  ����� o  ���B�B 0 errmsg errMsg� m  ���� ��� Z B o o t   o p t i o n   d o e s   n o t   m a t c h   X M L   r e p r e s e n t a t i o n� E  ����� o  ���A�A 0 errmsg errMsg� m  ���� ��� d C o u l d n ' t   f i n d   a   v a l i d   v o l u m e   U U I D   i n   t h e   b o o t   p a t h� k  ���� ��� r  ����� m  ���� ���  � o      �@�@ 0 devdisk devDisk� ��� r  ����� I ���?��
�? .sysoexecTEXT���     TEXT� b  ����� b  ����� m  ���� ���  s u d o   '� o  ���>�> 0 	resources  � m  ���� ���  s y s t e m d i s k s . s h '� �=��<
�= 
badm� m  ���;
�; boovtrue�<  � o      �:�: 0 startupdisk startupDisk� ��9� l ���8�7�6�8  �7  �6  �9  �E  � k  ��� ��� I ���5��
�5 .sysodlogaskr        TEXT� o  ���4�4 0 errmsg errMsg� �3��
�3 
btns� J  ���� ��2� m  ���� ���  C a n c e l�2  � �1��
�1 
dflt� m  ���0�0 � �/��
�/ 
disp� m  ���.�.  � �-��,
�- 
appr� m  ���� ��� R C h e c k   y o u r   d e f a u l t   u s e r n a m e   a n d   p a s s w o r d .�,  � ��+� I  �*�)�(
�* .aevtquitnull��� ��� null�)  �(  �+  � ��'� l �&�%�$�&  �%  �$  �'  ( ��� l �#�"�!�#  �"  �!  � ��� l � ���   �  �  � ��� Z  9����� = ��� o  �� 0 startupdisk startupDisk� m  �� ���  � r  5��� n  /��� 7 !/���
� 
ctxt� m  ')�� � m  *.����� l !���� I !���
� .earsffdralis        afdr� m  �
� afdrboot� ���
� 
rtyp� m  �
� 
TEXT�  �  �  � o      �� 0 startupdisk startupDisk�  �  � ��� l ::����  �  �  � ��� r  :e��� l :a���� I :a�
��
�
 .gtqpchltns    @   @ ns  � o  :=�	�	  0 getsystemdisks getSystemDisks� ���
� 
prmp� m  @C�� ��� 8 P l e a s e   S e l e c t   a   S t a r t u p   D i s k� ���
� 
inSL� o  FK�� 0 startupdisk startupDisk� ���
� 
okbt� J  NS�� ��� m  NQ�� ���  S e l e c t�  � � �
� 
cnbt  J  V[ � m  VY �  C a n c e l�  �  �  �  � o      � �   0 newstartupdisk newStartupDisk�  l ff��������  ��  ��    Z  f�	
����	 > fk o  fi����  0 newstartupdisk newStartupDisk m  ij��
�� boovfals
 k  n�  l nn��������  ��  ��    Q  nD k  q(  l qq����   ! This is where the action is    � 6 T h i s   i s   w h e r e   t h e   a c t i o n   i s  Z  q&�� o  qr���� 0 	disklabel 	diskLabel k  u�   !"! l uu��������  ��  ��  " #��# Z  u�$%��&$ o  uv���� 0 usemountonly useMountOnly% I y���'(
�� .sysoexecTEXT���     TEXT' b  y�)*) b  y�+,+ b  y�-.- b  y�/0/ b  y�121 b  y�343 m  y|55 �66 
 s u d o  4 o  |���� 	0 bless  2 m  ��77 �88 &   - - m o u n t   / V o l u m e s / '0 o  ������  0 newstartupdisk newStartupDisk. m  ��99 �:: * '   - - s e t B o o t   - - l a b e l   ', o  ������  0 newstartupdisk newStartupDisk* m  ��;; �<<  '( ��=��
�� 
badm= m  ����
�� boovtrue��  ��  & I ����>?
�� .sysoexecTEXT���     TEXT> b  ��@A@ b  ��BCB b  ��DED b  ��FGF b  ��HIH b  ��JKJ b  ��LML b  ��NON b  ��PQP b  ��RSR m  ��TT �UU 
 s u d o  S o  ������ 	0 bless  Q m  ��VV �WW $   - - f i l e   / V o l u m e s / 'O o  ������  0 newstartupdisk newStartupDiskM m  ��XX �YY v ' / S y s t e m / L i b r a r y / C o r e S e r v i c e s / b o o t . e f i     - - f o l d e r   / V o l u m e s / 'K o  ������  0 newstartupdisk newStartupDiskI m  ��ZZ �[[ ` ' / S y s t e m / L i b r a r y / C o r e S e r v i c e s   - - m o u n t   / V o l u m e s / 'G o  ������  0 newstartupdisk newStartupDiskE m  ��\\ �]] F '   - - s e t B o o t   - - p e r s o n a l i z e   - - l a b e l   'C o  ������  0 newstartupdisk newStartupDiskA m  ��^^ �__  '? ��`��
�� 
badm` m  ����
�� boovtrue��  ��  ��   k  �&aa bcb Z  �$de��fd o  ������ 0 usemountonly useMountOnlye k  ��gg hih I ����jk
�� .sysoexecTEXT���     TEXTj b  ��lml b  ��non b  ��pqp b  ��rsr m  ��tt �uu 
 s u d o  s o  ������ 	0 bless  q m  ��vv �ww &   - - m o u n t   / V o l u m e s / 'o o  ������  0 newstartupdisk newStartupDiskm m  ��xx �yy  '   - - s e t B o o tk ��z��
�� 
badmz m  ����
�� boovtrue��  i {��{ l ����������  ��  ��  ��  ��  f I �$��|}
�� .sysoexecTEXT���     TEXT| b  �~~ b  ���� b  ���� b  ���� b  ���� b  ���� b  ���� b  � ��� m  ���� ��� 
 s u d o  � o  ������ 	0 bless  � m   �� ��� $   - - f i l e   / V o l u m e s / '� o  ����  0 newstartupdisk newStartupDisk� m  �� ��� v ' / S y s t e m / L i b r a r y / C o r e S e r v i c e s / b o o t . e f i     - - f o l d e r   / V o l u m e s / '� o  ����  0 newstartupdisk newStartupDisk� m  �� ��� ` ' / S y s t e m / L i b r a r y / C o r e S e r v i c e s   - - m o u n t   / V o l u m e s / '� o  ����  0 newstartupdisk newStartupDisk m  �� ��� 2 '   - - s e t B o o t   - - p e r s o n a l i z e} �����
�� 
badm� m   ��
�� boovtrue��  c ���� l %%��������  ��  ��  ��   ���� l ''��������  ��  ��  ��   R      �����
�� .ascrerr ****      � ****� o      ���� 0 errmsg errMsg��   k  0D�� ��� l 00��������  ��  ��  � ���� I 0D����
�� .sysodlogaskr        TEXT� b  0:��� n  06��� 4 16���
�� 
cpar� m  45������� o  01���� 0 errmsg errMsg� m  69�� ���  .� �����
�� 
appr� m  =@�� ��� D A r e   y o u   s u r e   t h a t   i s   s t a r t u p   d i s k ?��  ��   ��� l EE��������  ��  ��  � ��� r  ER��� c  EL��� o  EH����  0 newstartupdisk newStartupDisk� m  HK��
�� 
TEXT� o      ���� 0 startupdisk startupDisk� ��� l SS��������  ��  ��  � ��� l SS��������  ��  ��  � ��� Z  Sh������ o  ST���� 0 
fastreboot 
fastReboot� r  W^��� o  WZ���� 0 fastrebootbtn fastRebootBtn� o      ���� 0 rebootbutton rebootButton��  � r  ah��� o  ad���� 0 	rebootbtn 	rebootBtn� o      ���� 0 rebootbutton rebootButton� ��� l ii��������  ��  ��  � ��� r  i���� I i�����
�� .sysodlogaskr        TEXT� b  ir��� o  in���� 0 startupdisk startupDisk� m  nq�� ��� 2   i s   t h e   n e w   S t a r t u p   D i s k .� ����
�� 
btns� J  u|�� ��� o  uv���� 0 	donatebtn 	donateBtn� ��� o  vy���� 0 	rebootbtn 	rebootBtn� ���� o  yz���� 0 quitbtn quitBtn��  � ����
�� 
dflt� m  ����� � ����
�� 
disp� m  ������ � �����
�� 
appr� m  ���� ��� < T h a n k   y o u   f o r   y o u r   c o o p e r a t i o n��  � o      ���� 0 
buttonsrtn 
buttonsRtn� ��� l ����������  ��  ��  � ��� Z  �������� = ����� n  ����� 1  ����
�� 
bhit� o  ������ 0 
buttonsrtn 
buttonsRtn� o  ������ 0 	donatebtn 	donateBtn� I �������
�� .GURLGURLnull��� ��� TEXT� o  ������ 0 donation  ��  � ��� = ����� n  ����� 1  ����
�� 
bhit� o  ������ 0 
buttonsrtn 
buttonsRtn� o  ������ 0 quitbtn quitBtn� ��� I ��������
�� .aevtquitnull��� ��� null��  ��  � ��� = ����� n  ����� 1  ����
�� 
bhit� o  ���� 0 
buttonsrtn 
buttonsRtn� o  ���~�~ 0 	rebootbtn 	rebootBtn� ��}� k  ���� ��� l ���|�{�z�|  �{  �z  � ��y� Z  �����x�� o  ���w�w 0 
fastreboot 
fastReboot� I ���v��
�v .sysoexecTEXT���     TEXT� m  ��   �  s u d o   r e b o o t   - q� �u�t
�u 
badm m  ���s
�s boovtrue�t  �x  � I ���r
�r .sysoexecTEXT���     TEXT m  �� �  s u d o   r e b o o t �q�p
�q 
badm m  ���o
�o boovtrue�p  �y  �}  ��  � 	 l ���n�m�l�n  �m  �l  	 
�k
 l ���j�i�h�j  �i  �h  �k  ��  ��    l ���g�f�e�g  �f  �e   �d l ���c�b�a�c  �b  �a  �d   �  = � n  � 1  ��`
�` 
bhit o  ���_�_ 0 
buttonsrtn 
buttonsRtn o  �^�^ 0 	donatebtn 	donateBtn �] I �\�[
�\ .GURLGURLnull��� ��� TEXT o  �Z�Z 0 donation  �[  �]  ��  ��  ��   � �Y l     �X�W�V�X  �W  �V  �Y       	�U 9 @ E f n w�U   �T�S�R�Q�P�O�N�T 0 
versiontag 
versionTag�S 0 user  �R 0 pass  �Q 0 startupdisk startupDisk�P 0 donation  �O 0 	bigmacurl 	bigmacURL
�N .aevtoappnull  �   � **** �M�L�K�J
�M .aevtoappnull  �   � **** k      I  Q  Y  z    �!!  �""  �##  �$$  �%%  �&&  �''  �((  ��I�I  �L  �K   �H�H 0 errmsg errMsg n�G�F�E �D ��C ��B ��A ��@ ��? ��> ��= ��< ��;�:�9�8 ��7�6�5�4�3�2 ��1�0�/�.�-�,�+;?�*IK�)�(�'�&�%�$X�#j�"|~�!� ����������������������579;TVXZ\^tvx���������� �G 0 	disklabel 	diskLabel�F 0 
fastreboot 
fastReboot�E 0 usemountonly useMountOnly�D (0 startupdiskchooser startupDiskChooser�C 0 	copyright  �B 0 	donatebtn 	donateBtn�A 0 selectdiskbtn selectDiskBtn�@ 0 quitbtn quitBtn�? 0 	githubbtn 	gitHubBtn�> 0 fastrebootbtn fastRebootBtn�= 0 	rebootbtn 	rebootBtn
�< 
ret 
�; 
btns
�: 
dflt
�9 
disp
�8 
appr�7 
�6 .sysodlogaskr        TEXT�5 0 
buttonsrtn 
buttonsRtn
�4 
bhit
�3 .GURLGURLnull��� ��� TEXT
�2 .aevtquitnull��� ��� null
�1 
rtyp
�0 
TEXT
�/ .earsffdralis        afdr�. 0 pp  �- 	0 bless  �, 0 	resources  
�+ 
psxp
�* 
bool
�) 
RAun
�( 
RApw
�' 
badm�& 
�% .sysoexecTEXT���     TEXT�$  0 getsystemdisks getSystemDisks
�# 
cpar�" 0 devdisk devDisk�! 0 errmsg errMsg�   
� afdrboot
� 
ctxt���
� 
prmp
� 
inSL
� 
okbt
� 
cnbt
� .gtqpchltns    @   @ ns  �  0 newstartupdisk newStartupDisk� 0 rebootbutton rebootButton�JeE�OfE�OfE�O�E�O�E�O�E�O�E�O�E�O�E�O�E` Oa E` Oa _ %a %_ %b   %a ���mva ka ka a a  E` O_ a ,�  b  j Y�_ a ,�  
*j  Y�_ a ,a ! [)a "a #l $E` %O_ %a &%E` 'O_ %a (%E` )O_ )a *,E` )O_ 'a *,E` 'O �b  a +	 b  a ,a -& .a ._ )%a /%a 0b  a 1b  a 2ea 3 4E` 5Y _ )a 6%a 2el 4E` 5O_ 5a 7-E` 5O_ 'a 8%j 4E` 9Oa :_ 9%a ;%a 2el 4Ec  W �X < =�a > 
*j  Y hO�a ?
 �a @a -&
 �a Aa -&
 �a Ba -& (a CE` 9Oa D_ )%a E%a 2el 4Ec  OPY %�a a Fkva ka ja a Ga  O*j  OPOb  a H  &a Ia "a #l $[a J\[Zk\Za K2Ec  Y hO_ 5a La Ma Nb  a Oa Pkva Qa Rkva  SE` TO_ Tf� �� b� (a U_ '%a V%_ T%a W%_ T%a X%a 2el 4Y 5a Y_ '%a Z%_ T%a [%_ T%a \%_ T%a ]%_ T%a ^%a 2el 4Y S� "a __ '%a `%_ T%a a%a 2el 4OPY -a b_ '%a c%_ T%a d%_ T%a e%_ T%a f%a 2el 4OPOPW X < =�a 7i/a g%a a hl O_ Ta #&Ec  O� _ E` iY 	_ E` iOb  a j%a �_ �mva ka ka a ka  E` O_ a ,�  b  j Y E_ a ,�  
*j  Y 1_ a ,_   "� a la 2el 4Y a ma 2el 4Y hOPY hOPY _ a ,�  b  j Y h ascr  ��ޭ