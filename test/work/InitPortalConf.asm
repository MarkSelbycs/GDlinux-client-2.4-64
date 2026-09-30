
samples/ESurfingSvr:     file format elf64-x86-64


Disassembly of section .text:

00000000004188f4 <CPortalConn::InitPortalConf()>:
  4188f4:	55                   	push   %rbp
  4188f5:	48 89 e5             	mov    %rsp,%rbp
  4188f8:	41 54                	push   %r12
  4188fa:	53                   	push   %rbx
  4188fb:	48 81 ec d0 01 00 00 	sub    $0x1d0,%rsp
  418902:	48 89 bd 28 fe ff ff 	mov    %rdi,-0x1d8(%rbp)
  418909:	bf 12 0c 45 00       	mov    $0x450c12,%edi
  41890e:	e8 7d b5 fe ff       	call   403e90 <puts@plt>
  418913:	bf e8 02 00 00       	mov    $0x2e8,%edi
  418918:	e8 d3 be fe ff       	call   4047f0 <operator new(unsigned long)@plt>
  41891d:	48 89 c3             	mov    %rax,%rbx
  418920:	48 89 df             	mov    %rbx,%rdi
  418923:	e8 6c 4b 00 00       	call   41d494 <CAuthConfig::CAuthConfig()>
  418928:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  41892f:	48 89 98 80 01 00 00 	mov    %rbx,0x180(%rax)
  418936:	e8 61 b9 00 00       	call   42429c <CPortalServer::GetInst()>
  41893b:	48 89 c7             	mov    %rax,%rdi
  41893e:	e8 15 ba 00 00       	call   424358 <CPortalServer::GetInfoCenter()>
  418943:	48 89 45 e8          	mov    %rax,-0x18(%rbp)
  418947:	48 8d 85 30 fe ff ff 	lea    -0x1d0(%rbp),%rax
  41894e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418952:	ba 24 0c 45 00       	mov    $0x450c24,%edx
  418957:	48 89 ce             	mov    %rcx,%rsi
  41895a:	48 89 c7             	mov    %rax,%rdi
  41895d:	e8 d6 50 ff ff       	call   40da38 <CInfoCenter::GetValue(char const*)>
  418962:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418969:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418970:	48 8d 90 30 01 00 00 	lea    0x130(%rax),%rdx
  418977:	48 8d 85 30 fe ff ff 	lea    -0x1d0(%rbp),%rax
  41897e:	48 89 c6             	mov    %rax,%rsi
  418981:	48 89 d7             	mov    %rdx,%rdi
  418984:	e8 b5 57 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418989:	48 8d 85 30 fe ff ff 	lea    -0x1d0(%rbp),%rax
  418990:	48 89 c7             	mov    %rax,%rdi
  418993:	e8 8c 57 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418998:	48 8d 85 40 fe ff ff 	lea    -0x1c0(%rbp),%rax
  41899f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  4189a3:	ba af 07 45 00       	mov    $0x4507af,%edx
  4189a8:	48 89 ce             	mov    %rcx,%rsi
  4189ab:	48 89 c7             	mov    %rax,%rdi
  4189ae:	e8 85 50 ff ff       	call   40da38 <CInfoCenter::GetValue(char const*)>
  4189b3:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  4189ba:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  4189c1:	48 8d 90 c0 00 00 00 	lea    0xc0(%rax),%rdx
  4189c8:	48 8d 85 40 fe ff ff 	lea    -0x1c0(%rbp),%rax
  4189cf:	48 89 c6             	mov    %rax,%rsi
  4189d2:	48 89 d7             	mov    %rdx,%rdi
  4189d5:	e8 64 57 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  4189da:	48 8d 85 40 fe ff ff 	lea    -0x1c0(%rbp),%rax
  4189e1:	48 89 c7             	mov    %rax,%rdi
  4189e4:	e8 3b 57 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  4189e9:	48 8d 85 50 fe ff ff 	lea    -0x1b0(%rbp),%rax
  4189f0:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  4189f4:	ba a7 07 45 00       	mov    $0x4507a7,%edx
  4189f9:	48 89 ce             	mov    %rcx,%rsi
  4189fc:	48 89 c7             	mov    %rax,%rdi
  4189ff:	e8 34 50 ff ff       	call   40da38 <CInfoCenter::GetValue(char const*)>
  418a04:	48 8d 85 50 fe ff ff 	lea    -0x1b0(%rbp),%rax
  418a0b:	48 89 c7             	mov    %rax,%rdi
  418a0e:	e8 c5 5b ff ff       	call   40e5d8 <CAutoString::GetBuffer() const>
  418a13:	48 8b 95 28 fe ff ff 	mov    -0x1d8(%rbp),%rdx
  418a1a:	48 8b 92 80 01 00 00 	mov    0x180(%rdx),%rdx
  418a21:	48 8d 8a 40 01 00 00 	lea    0x140(%rdx),%rcx
  418a28:	48 89 c2             	mov    %rax,%rdx
  418a2b:	be 00 0a 45 00       	mov    $0x450a00,%esi
  418a30:	48 89 cf             	mov    %rcx,%rdi
  418a33:	b8 00 00 00 00       	mov    $0x0,%eax
  418a38:	e8 a3 59 ff ff       	call   40e3e0 <CAutoString::Format(char const*, ...)>
  418a3d:	48 8d 85 50 fe ff ff 	lea    -0x1b0(%rbp),%rax
  418a44:	48 89 c7             	mov    %rax,%rdi
  418a47:	e8 d8 56 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418a4c:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418a53:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418a5a:	48 05 40 01 00 00    	add    $0x140,%rax
  418a60:	48 89 c7             	mov    %rax,%rdi
  418a63:	e8 70 5b ff ff       	call   40e5d8 <CAutoString::GetBuffer() const>
  418a68:	48 89 c3             	mov    %rax,%rbx
  418a6b:	e8 54 74 ff ff       	call   40fec4 <CLog::GetInst()>
  418a70:	48 89 d9             	mov    %rbx,%rcx
  418a73:	ba 2d 0c 45 00       	mov    $0x450c2d,%edx
  418a78:	be 03 00 00 00       	mov    $0x3,%esi
  418a7d:	48 89 c7             	mov    %rax,%rdi
  418a80:	b8 00 00 00 00       	mov    $0x0,%eax
  418a85:	e8 48 74 ff ff       	call   40fed2 <CLog::WriteLog(int, char const*, ...)>
  418a8a:	48 8d 85 60 fe ff ff 	lea    -0x1a0(%rbp),%rax
  418a91:	be 3b 0c 45 00       	mov    $0x450c3b,%esi
  418a96:	48 89 c7             	mov    %rax,%rdi
  418a99:	e8 86 55 ff ff       	call   40e024 <CAutoString::CAutoString(char const*)>
  418a9e:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418aa5:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418aac:	48 8d 90 f0 00 00 00 	lea    0xf0(%rax),%rdx
  418ab3:	48 8d 85 60 fe ff ff 	lea    -0x1a0(%rbp),%rax
  418aba:	48 89 c6             	mov    %rax,%rsi
  418abd:	48 89 d7             	mov    %rdx,%rdi
  418ac0:	e8 79 56 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418ac5:	48 8d 85 60 fe ff ff 	lea    -0x1a0(%rbp),%rax
  418acc:	48 89 c7             	mov    %rax,%rdi
  418acf:	e8 50 56 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418ad4:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418adb:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418ae2:	48 05 40 01 00 00    	add    $0x140,%rax
  418ae8:	48 89 c7             	mov    %rax,%rdi
  418aeb:	e8 e8 5a ff ff       	call   40e5d8 <CAutoString::GetBuffer() const>
  418af0:	48 8b 95 28 fe ff ff 	mov    -0x1d8(%rbp),%rdx
  418af7:	48 8b 92 80 01 00 00 	mov    0x180(%rdx),%rdx
  418afe:	48 8d 8a d0 00 00 00 	lea    0xd0(%rdx),%rcx
  418b05:	48 89 c2             	mov    %rax,%rdx
  418b08:	be 43 0c 45 00       	mov    $0x450c43,%esi
  418b0d:	48 89 cf             	mov    %rcx,%rdi
  418b10:	b8 00 00 00 00       	mov    $0x0,%eax
  418b15:	e8 c6 58 ff ff       	call   40e3e0 <CAutoString::Format(char const*, ...)>
  418b1a:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418b21:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418b28:	48 05 d0 00 00 00    	add    $0xd0,%rax
  418b2e:	48 89 c7             	mov    %rax,%rdi
  418b31:	e8 a2 5a ff ff       	call   40e5d8 <CAutoString::GetBuffer() const>
  418b36:	49 89 c4             	mov    %rax,%r12
  418b39:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418b40:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418b47:	48 05 f0 00 00 00    	add    $0xf0,%rax
  418b4d:	48 89 c7             	mov    %rax,%rdi
  418b50:	e8 83 5a ff ff       	call   40e5d8 <CAutoString::GetBuffer() const>
  418b55:	48 89 c3             	mov    %rax,%rbx
  418b58:	e8 67 73 ff ff       	call   40fec4 <CLog::GetInst()>
  418b5d:	4d 89 e0             	mov    %r12,%r8
  418b60:	48 89 d9             	mov    %rbx,%rcx
  418b63:	ba 53 0c 45 00       	mov    $0x450c53,%edx
  418b68:	be 03 00 00 00       	mov    $0x3,%esi
  418b6d:	48 89 c7             	mov    %rax,%rdi
  418b70:	b8 00 00 00 00       	mov    $0x0,%eax
  418b75:	e8 58 73 ff ff       	call   40fed2 <CLog::WriteLog(int, char const*, ...)>
  418b7a:	48 8d 85 70 fe ff ff 	lea    -0x190(%rbp),%rax
  418b81:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418b85:	ba 6c 0c 45 00       	mov    $0x450c6c,%edx
  418b8a:	48 89 ce             	mov    %rcx,%rsi
  418b8d:	48 89 c7             	mov    %rax,%rdi
  418b90:	e8 c5 51 ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418b95:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418b9c:	48 8d 90 98 00 00 00 	lea    0x98(%rax),%rdx
  418ba3:	48 8d 85 70 fe ff ff 	lea    -0x190(%rbp),%rax
  418baa:	48 89 c6             	mov    %rax,%rsi
  418bad:	48 89 d7             	mov    %rdx,%rdi
  418bb0:	e8 89 55 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418bb5:	48 8d 85 70 fe ff ff 	lea    -0x190(%rbp),%rax
  418bbc:	48 89 c7             	mov    %rax,%rdi
  418bbf:	e8 60 55 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418bc4:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418bcb:	48 05 98 00 00 00    	add    $0x98,%rax
  418bd1:	48 89 c7             	mov    %rax,%rdi
  418bd4:	e8 11 5a ff ff       	call   40e5ea <CAutoString::GetLength() const>
  418bd9:	85 c0                	test   %eax,%eax
  418bdb:	0f 94 c0             	sete   %al
  418bde:	84 c0                	test   %al,%al
  418be0:	74 43                	je     418c25 <CPortalConn::InitPortalConf()+0x331>
  418be2:	48 8d 85 80 fe ff ff 	lea    -0x180(%rbp),%rax
  418be9:	be 78 0c 45 00       	mov    $0x450c78,%esi
  418bee:	48 89 c7             	mov    %rax,%rdi
  418bf1:	e8 2e 54 ff ff       	call   40e024 <CAutoString::CAutoString(char const*)>
  418bf6:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418bfd:	48 8d 90 98 00 00 00 	lea    0x98(%rax),%rdx
  418c04:	48 8d 85 80 fe ff ff 	lea    -0x180(%rbp),%rax
  418c0b:	48 89 c6             	mov    %rax,%rsi
  418c0e:	48 89 d7             	mov    %rdx,%rdi
  418c11:	e8 28 55 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418c16:	48 8d 85 80 fe ff ff 	lea    -0x180(%rbp),%rax
  418c1d:	48 89 c7             	mov    %rax,%rdi
  418c20:	e8 ff 54 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418c25:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
  418c2c:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418c30:	ba 9b 0c 45 00       	mov    $0x450c9b,%edx
  418c35:	48 89 ce             	mov    %rcx,%rsi
  418c38:	48 89 c7             	mov    %rax,%rdi
  418c3b:	e8 1a 51 ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418c40:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418c47:	48 8d 90 a8 00 00 00 	lea    0xa8(%rax),%rdx
  418c4e:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
  418c55:	48 89 c6             	mov    %rax,%rsi
  418c58:	48 89 d7             	mov    %rdx,%rdi
  418c5b:	e8 de 54 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418c60:	48 8d 85 90 fe ff ff 	lea    -0x170(%rbp),%rax
  418c67:	48 89 c7             	mov    %rax,%rdi
  418c6a:	e8 b5 54 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418c6f:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418c76:	48 05 a8 00 00 00    	add    $0xa8,%rax
  418c7c:	48 89 c7             	mov    %rax,%rdi
  418c7f:	e8 66 59 ff ff       	call   40e5ea <CAutoString::GetLength() const>
  418c84:	85 c0                	test   %eax,%eax
  418c86:	0f 94 c0             	sete   %al
  418c89:	84 c0                	test   %al,%al
  418c8b:	74 43                	je     418cd0 <CPortalConn::InitPortalConf()+0x3dc>
  418c8d:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
  418c94:	be a8 0c 45 00       	mov    $0x450ca8,%esi
  418c99:	48 89 c7             	mov    %rax,%rdi
  418c9c:	e8 83 53 ff ff       	call   40e024 <CAutoString::CAutoString(char const*)>
  418ca1:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418ca8:	48 8d 90 a8 00 00 00 	lea    0xa8(%rax),%rdx
  418caf:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
  418cb6:	48 89 c6             	mov    %rax,%rsi
  418cb9:	48 89 d7             	mov    %rdx,%rdi
  418cbc:	e8 7d 54 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418cc1:	48 8d 85 a0 fe ff ff 	lea    -0x160(%rbp),%rax
  418cc8:	48 89 c7             	mov    %rax,%rdi
  418ccb:	e8 54 54 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418cd0:	48 8d 85 b0 fe ff ff 	lea    -0x150(%rbp),%rax
  418cd7:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418cdb:	ba be 0c 45 00       	mov    $0x450cbe,%edx
  418ce0:	48 89 ce             	mov    %rcx,%rsi
  418ce3:	48 89 c7             	mov    %rax,%rdi
  418ce6:	e8 6f 50 ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418ceb:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418cf2:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418cf9:	48 8d 90 88 00 00 00 	lea    0x88(%rax),%rdx
  418d00:	48 8d 85 b0 fe ff ff 	lea    -0x150(%rbp),%rax
  418d07:	48 89 c6             	mov    %rax,%rsi
  418d0a:	48 89 d7             	mov    %rdx,%rdi
  418d0d:	e8 2c 54 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418d12:	48 8d 85 b0 fe ff ff 	lea    -0x150(%rbp),%rax
  418d19:	48 89 c7             	mov    %rax,%rdi
  418d1c:	e8 03 54 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418d21:	48 8d 85 c0 fe ff ff 	lea    -0x140(%rbp),%rax
  418d28:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418d2c:	ba c6 0c 45 00       	mov    $0x450cc6,%edx
  418d31:	48 89 ce             	mov    %rcx,%rsi
  418d34:	48 89 c7             	mov    %rax,%rdi
  418d37:	e8 1e 50 ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418d3c:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418d43:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418d4a:	48 8d 90 98 00 00 00 	lea    0x98(%rax),%rdx
  418d51:	48 8d 85 c0 fe ff ff 	lea    -0x140(%rbp),%rax
  418d58:	48 89 c6             	mov    %rax,%rsi
  418d5b:	48 89 d7             	mov    %rdx,%rdi
  418d5e:	e8 db 53 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418d63:	48 8d 85 c0 fe ff ff 	lea    -0x140(%rbp),%rax
  418d6a:	48 89 c7             	mov    %rax,%rdi
  418d6d:	e8 b2 53 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418d72:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418d79:	48 8b 98 80 01 00 00 	mov    0x180(%rax),%rbx
  418d80:	48 8d 85 d0 fe ff ff 	lea    -0x130(%rbp),%rax
  418d87:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418d8b:	ba ce 0c 45 00       	mov    $0x450cce,%edx
  418d90:	48 89 ce             	mov    %rcx,%rsi
  418d93:	48 89 c7             	mov    %rax,%rdi
  418d96:	e8 bf 4f ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418d9b:	48 8d 85 d0 fe ff ff 	lea    -0x130(%rbp),%rax
  418da2:	48 89 c7             	mov    %rax,%rdi
  418da5:	e8 5e 55 ff ff       	call   40e308 <CAutoString::operator char const*()>
  418daa:	48 89 c7             	mov    %rax,%rdi
  418dad:	e8 de b5 fe ff       	call   404390 <atoi@plt>
  418db2:	89 83 e0 00 00 00    	mov    %eax,0xe0(%rbx)
  418db8:	48 8d 85 d0 fe ff ff 	lea    -0x130(%rbp),%rax
  418dbf:	48 89 c7             	mov    %rax,%rdi
  418dc2:	e8 5d 53 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418dc7:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
  418dce:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418dd2:	ba 00 0b 45 00       	mov    $0x450b00,%edx
  418dd7:	48 89 ce             	mov    %rcx,%rsi
  418dda:	48 89 c7             	mov    %rax,%rdi
  418ddd:	e8 78 4f ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418de2:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418de9:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418df0:	48 8d 90 a8 00 00 00 	lea    0xa8(%rax),%rdx
  418df7:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
  418dfe:	48 89 c6             	mov    %rax,%rsi
  418e01:	48 89 d7             	mov    %rdx,%rdi
  418e04:	e8 35 53 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418e09:	48 8d 85 e0 fe ff ff 	lea    -0x120(%rbp),%rax
  418e10:	48 89 c7             	mov    %rax,%rdi
  418e13:	e8 0c 53 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418e18:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  418e1f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418e23:	ba 92 07 45 00       	mov    $0x450792,%edx
  418e28:	48 89 ce             	mov    %rcx,%rsi
  418e2b:	48 89 c7             	mov    %rax,%rdi
  418e2e:	e8 27 4f ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418e33:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418e3a:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418e41:	48 8d 50 30          	lea    0x30(%rax),%rdx
  418e45:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  418e4c:	48 89 c6             	mov    %rax,%rsi
  418e4f:	48 89 d7             	mov    %rdx,%rdi
  418e52:	e8 e7 52 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418e57:	48 8d 85 f0 fe ff ff 	lea    -0x110(%rbp),%rax
  418e5e:	48 89 c7             	mov    %rax,%rdi
  418e61:	e8 be 52 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418e66:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418e6d:	48 8b 98 80 01 00 00 	mov    0x180(%rax),%rbx
  418e74:	48 8d 85 00 ff ff ff 	lea    -0x100(%rbp),%rax
  418e7b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418e7f:	ba 9b 07 45 00       	mov    $0x45079b,%edx
  418e84:	48 89 ce             	mov    %rcx,%rsi
  418e87:	48 89 c7             	mov    %rax,%rdi
  418e8a:	e8 cb 4e ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418e8f:	48 8d 85 00 ff ff ff 	lea    -0x100(%rbp),%rax
  418e96:	48 89 c7             	mov    %rax,%rdi
  418e99:	e8 6a 54 ff ff       	call   40e308 <CAutoString::operator char const*()>
  418e9e:	48 89 c7             	mov    %rax,%rdi
  418ea1:	e8 ea b4 fe ff       	call   404390 <atoi@plt>
  418ea6:	89 43 40             	mov    %eax,0x40(%rbx)
  418ea9:	48 8d 85 00 ff ff ff 	lea    -0x100(%rbp),%rax
  418eb0:	48 89 c7             	mov    %rax,%rdi
  418eb3:	e8 6c 52 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418eb8:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418ebf:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418ec6:	8b 40 40             	mov    0x40(%rax),%eax
  418ec9:	85 c0                	test   %eax,%eax
  418ecb:	75 15                	jne    418ee2 <CPortalConn::InitPortalConf()+0x5ee>
  418ecd:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418ed4:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418edb:	c7 40 40 01 00 00 00 	movl   $0x1,0x40(%rax)
  418ee2:	48 8d 85 10 ff ff ff 	lea    -0xf0(%rbp),%rax
  418ee9:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418eed:	ba 62 07 45 00       	mov    $0x450762,%edx
  418ef2:	48 89 ce             	mov    %rcx,%rsi
  418ef5:	48 89 c7             	mov    %rax,%rdi
  418ef8:	e8 5d 4e ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418efd:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418f04:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418f0b:	48 8d 90 00 02 00 00 	lea    0x200(%rax),%rdx
  418f12:	48 8d 85 10 ff ff ff 	lea    -0xf0(%rbp),%rax
  418f19:	48 89 c6             	mov    %rax,%rsi
  418f1c:	48 89 d7             	mov    %rdx,%rdi
  418f1f:	e8 1a 52 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418f24:	48 8d 85 10 ff ff ff 	lea    -0xf0(%rbp),%rax
  418f2b:	48 89 c7             	mov    %rax,%rdi
  418f2e:	e8 f1 51 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418f33:	48 8d 85 20 ff ff ff 	lea    -0xe0(%rbp),%rax
  418f3a:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418f3e:	ba 6b 07 45 00       	mov    $0x45076b,%edx
  418f43:	48 89 ce             	mov    %rcx,%rsi
  418f46:	48 89 c7             	mov    %rax,%rdi
  418f49:	e8 0c 4e ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418f4e:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418f55:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418f5c:	48 8d 90 10 02 00 00 	lea    0x210(%rax),%rdx
  418f63:	48 8d 85 20 ff ff ff 	lea    -0xe0(%rbp),%rax
  418f6a:	48 89 c6             	mov    %rax,%rsi
  418f6d:	48 89 d7             	mov    %rdx,%rdi
  418f70:	e8 c9 51 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418f75:	48 8d 85 20 ff ff ff 	lea    -0xe0(%rbp),%rax
  418f7c:	48 89 c7             	mov    %rax,%rdi
  418f7f:	e8 a0 51 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418f84:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  418f8b:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418f8f:	ba 72 07 45 00       	mov    $0x450772,%edx
  418f94:	48 89 ce             	mov    %rcx,%rsi
  418f97:	48 89 c7             	mov    %rax,%rdi
  418f9a:	e8 bb 4d ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418f9f:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418fa6:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418fad:	48 8d 90 20 02 00 00 	lea    0x220(%rax),%rdx
  418fb4:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  418fbb:	48 89 c6             	mov    %rax,%rsi
  418fbe:	48 89 d7             	mov    %rdx,%rdi
  418fc1:	e8 78 51 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  418fc6:	48 8d 85 30 ff ff ff 	lea    -0xd0(%rbp),%rax
  418fcd:	48 89 c7             	mov    %rax,%rdi
  418fd0:	e8 4f 51 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  418fd5:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  418fdc:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  418fe0:	ba 33 07 45 00       	mov    $0x450733,%edx
  418fe5:	48 89 ce             	mov    %rcx,%rsi
  418fe8:	48 89 c7             	mov    %rax,%rdi
  418feb:	e8 6a 4d ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  418ff0:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  418ff7:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  418ffe:	48 8d 90 30 02 00 00 	lea    0x230(%rax),%rdx
  419005:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  41900c:	48 89 c6             	mov    %rax,%rsi
  41900f:	48 89 d7             	mov    %rdx,%rdi
  419012:	e8 27 51 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  419017:	48 8d 85 40 ff ff ff 	lea    -0xc0(%rbp),%rax
  41901e:	48 89 c7             	mov    %rax,%rdi
  419021:	e8 fe 50 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  419026:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  41902d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  419031:	ba 3e 07 45 00       	mov    $0x45073e,%edx
  419036:	48 89 ce             	mov    %rcx,%rsi
  419039:	48 89 c7             	mov    %rax,%rdi
  41903c:	e8 19 4d ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  419041:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  419048:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  41904f:	48 8d 90 40 02 00 00 	lea    0x240(%rax),%rdx
  419056:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  41905d:	48 89 c6             	mov    %rax,%rsi
  419060:	48 89 d7             	mov    %rdx,%rdi
  419063:	e8 d6 50 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  419068:	48 8d 85 50 ff ff ff 	lea    -0xb0(%rbp),%rax
  41906f:	48 89 c7             	mov    %rax,%rdi
  419072:	e8 ad 50 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  419077:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  41907e:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  419082:	ba 59 07 45 00       	mov    $0x450759,%edx
  419087:	48 89 ce             	mov    %rcx,%rsi
  41908a:	48 89 c7             	mov    %rax,%rdi
  41908d:	e8 c8 4c ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  419092:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  419099:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  4190a0:	48 8d 90 50 02 00 00 	lea    0x250(%rax),%rdx
  4190a7:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  4190ae:	48 89 c6             	mov    %rax,%rsi
  4190b1:	48 89 d7             	mov    %rdx,%rdi
  4190b4:	e8 85 50 ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  4190b9:	48 8d 85 60 ff ff ff 	lea    -0xa0(%rbp),%rax
  4190c0:	48 89 c7             	mov    %rax,%rdi
  4190c3:	e8 5c 50 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  4190c8:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  4190cf:	48 8b 98 80 01 00 00 	mov    0x180(%rax),%rbx
  4190d6:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  4190dd:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  4190e1:	ba d8 0c 45 00       	mov    $0x450cd8,%edx
  4190e6:	48 89 ce             	mov    %rcx,%rsi
  4190e9:	48 89 c7             	mov    %rax,%rdi
  4190ec:	e8 69 4c ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  4190f1:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  4190f8:	48 89 c7             	mov    %rax,%rdi
  4190fb:	e8 08 52 ff ff       	call   40e308 <CAutoString::operator char const*()>
  419100:	48 89 c7             	mov    %rax,%rdi
  419103:	e8 88 b2 fe ff       	call   404390 <atoi@plt>
  419108:	89 83 78 02 00 00    	mov    %eax,0x278(%rbx)
  41910e:	48 8d 85 70 ff ff ff 	lea    -0x90(%rbp),%rax
  419115:	48 89 c7             	mov    %rax,%rdi
  419118:	e8 07 50 ff ff       	call   40e124 <CAutoString::~CAutoString()>
  41911d:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  419124:	48 8b 98 80 01 00 00 	mov    0x180(%rax),%rbx
  41912b:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  41912f:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  419133:	ba e5 0c 45 00       	mov    $0x450ce5,%edx
  419138:	48 89 ce             	mov    %rcx,%rsi
  41913b:	48 89 c7             	mov    %rax,%rdi
  41913e:	e8 17 4c ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  419143:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  419147:	48 89 c7             	mov    %rax,%rdi
  41914a:	e8 b9 51 ff ff       	call   40e308 <CAutoString::operator char const*()>
  41914f:	48 89 c7             	mov    %rax,%rdi
  419152:	e8 39 b2 fe ff       	call   404390 <atoi@plt>
  419157:	89 83 7c 02 00 00    	mov    %eax,0x27c(%rbx)
  41915d:	48 8d 45 80          	lea    -0x80(%rbp),%rax
  419161:	48 89 c7             	mov    %rax,%rdi
  419164:	e8 bb 4f ff ff       	call   40e124 <CAutoString::~CAutoString()>
  419169:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  41916d:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  419171:	ba ee 0c 45 00       	mov    $0x450cee,%edx
  419176:	48 89 ce             	mov    %rcx,%rsi
  419179:	48 89 c7             	mov    %rax,%rdi
  41917c:	e8 d9 4b ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  419181:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  419188:	48 8d 90 20 01 00 00 	lea    0x120(%rax),%rdx
  41918f:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  419193:	48 89 c6             	mov    %rax,%rsi
  419196:	48 89 d7             	mov    %rdx,%rdi
  419199:	e8 a0 4f ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  41919e:	48 8d 45 90          	lea    -0x70(%rbp),%rax
  4191a2:	48 89 c7             	mov    %rax,%rdi
  4191a5:	e8 7a 4f ff ff       	call   40e124 <CAutoString::~CAutoString()>
  4191aa:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  4191ae:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  4191b2:	ba c7 07 45 00       	mov    $0x4507c7,%edx
  4191b7:	48 89 ce             	mov    %rcx,%rsi
  4191ba:	48 89 c7             	mov    %rax,%rdi
  4191bd:	e8 98 4b ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  4191c2:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  4191c9:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  4191d0:	48 8d 90 88 02 00 00 	lea    0x288(%rax),%rdx
  4191d7:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  4191db:	48 89 c6             	mov    %rax,%rsi
  4191de:	48 89 d7             	mov    %rdx,%rdi
  4191e1:	e8 58 4f ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  4191e6:	48 8d 45 a0          	lea    -0x60(%rbp),%rax
  4191ea:	48 89 c7             	mov    %rax,%rdi
  4191ed:	e8 32 4f ff ff       	call   40e124 <CAutoString::~CAutoString()>
  4191f2:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  4191f6:	48 8b 4d e8          	mov    -0x18(%rbp),%rcx
  4191fa:	ba b8 07 45 00       	mov    $0x4507b8,%edx
  4191ff:	48 89 ce             	mov    %rcx,%rsi
  419202:	48 89 c7             	mov    %rax,%rdi
  419205:	e8 50 4b ff ff       	call   40dd5a <CInfoCenter::GetLocalValue(char const*)>
  41920a:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  419211:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  419218:	48 8d 90 98 02 00 00 	lea    0x298(%rax),%rdx
  41921f:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  419223:	48 89 c6             	mov    %rax,%rsi
  419226:	48 89 d7             	mov    %rdx,%rdi
  419229:	e8 10 4f ff ff       	call   40e13e <CAutoString::operator=(CAutoString const&)>
  41922e:	48 8d 45 b0          	lea    -0x50(%rbp),%rax
  419232:	48 89 c7             	mov    %rax,%rdi
  419235:	e8 ea 4e ff ff       	call   40e124 <CAutoString::~CAutoString()>
  41923a:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  419241:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  419248:	48 05 88 02 00 00    	add    $0x288,%rax
  41924e:	48 89 c7             	mov    %rax,%rdi
  419251:	e8 94 53 ff ff       	call   40e5ea <CAutoString::GetLength() const>
  419256:	85 c0                	test   %eax,%eax
  419258:	0f 95 c0             	setne  %al
  41925b:	84 c0                	test   %al,%al
  41925d:	74 73                	je     4192d2 <CPortalConn::InitPortalConf()+0x9de>
  41925f:	48 8d 45 cf          	lea    -0x31(%rbp),%rax
  419263:	48 89 c7             	mov    %rax,%rdi
  419266:	e8 05 b5 fe ff       	call   404770 <std::allocator<char>::allocator()@plt>
  41926b:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  419272:	48 8b 80 80 01 00 00 	mov    0x180(%rax),%rax
  419279:	48 05 88 02 00 00    	add    $0x288,%rax
  41927f:	48 89 c7             	mov    %rax,%rdi
  419282:	e8 81 50 ff ff       	call   40e308 <CAutoString::operator char const*()>
  419287:	48 89 c1             	mov    %rax,%rcx
  41928a:	48 8d 55 cf          	lea    -0x31(%rbp),%rdx
  41928e:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  419292:	48 89 ce             	mov    %rcx,%rsi
  419295:	48 89 c7             	mov    %rax,%rdi
  419298:	e8 23 b0 fe ff       	call   4042c0 <std::basic_string<char, std::char_traits<char>, std::allocator<char> >::basic_string(char const*, std::allocator<char> const&)@plt>
  41929d:	48 8b 85 28 fe ff ff 	mov    -0x1d8(%rbp),%rax
  4192a4:	48 8d 90 90 01 00 00 	lea    0x190(%rax),%rdx
  4192ab:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  4192af:	48 89 c6             	mov    %rax,%rsi
  4192b2:	48 89 d7             	mov    %rdx,%rdi
  4192b5:	e8 86 4a 00 00       	call   41dd40 <HashBalance::SetIpList(std::string const&)>
  4192ba:	48 8d 45 c0          	lea    -0x40(%rbp),%rax
  4192be:	48                   	rex.W
  4192bf:	89                   	.byte 0x89
